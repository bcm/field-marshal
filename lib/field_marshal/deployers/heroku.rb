require 'excon'
require 'platform-api'

module FieldMarshal
  module Deployers
    class Heroku
      include Virtus.value_object(strict: true)

      attribute :app_name,    String
      attribute :api_token,   String
      attribute :git_url,     String
      attribute :git_branch,  String
      attribute :working_dir, String

      def remote_git_url
        @remote_git_url ||= app['git_url']
      end

      def git_remote
        @git_remote ||= begin
          remote_git_url =~ /^git\@heroku\.com\:(.+)\.git$/
          $1
        end
      end

      def detect_database_migrations(remote_host)
        cmd = "cd #{working_dir} && git diff #{git_branch} #{git_remote}/master --name-only -- db/migrate | wc -l"
        remote_host.exec(cmd) do |channel, data|
          @migration_count = data.strip!.to_i
        end
      end

      def turn_on_maintenance_mode(remote_host)
        if migration_count > 0
          api.app.update(app_name, maintenance: true)
        end
      end

      def turn_off_maintenance_mode(remote_host)
        api.app.update(app_name, maintenance: false)
      end

      def scale_down(remote_host)
        if migration_count > 0
          updates = process_counts.each_with_object([]) do |(process_type, count), m|
            m << {'process' => process_type.to_s, 'quantity' => 0} if count > 0
          end
          api.formation.batch_update(app_name, 'updates' => updates)
        end
      end

      def scale_up(remote_host)
        updates = process_counts.each_with_object([]) do |(process_type, count), m|
          m << {'process' => process_type.to_s, 'quantity' => count}
        end
        api.formation.batch_update(app_name, 'updates' => updates)
      end

      def deploy_application(remote_host)
        cmd = "cd #{working_dir} && git push #{git_remote} #{git_branch}:master"
        remote_host.exec(cmd)
      end

      def roll_back_to_previous_release(remote_host)
        # so lame that we have to make a completely separate connection to reorder a list response
        list_client = PlatformAPI.connect_oauth(api_token,
          default_headers: {'Range' => 'version ..; order=desc,max=2'})
        releases = list_client.release.list(app_name)
        releases.next # skip the current release
        previous_release = releases.next
                if previous_release
          api.release.rollback(app_name, release: previous_release['id'])
        end
      end

      def apply_database_migrations(remote_host)
        if migration_count > 0
          dyno = api.dyno.create(app_name, command: 'rake db:migrate')
          poll_one_off_dyno_until_done(dyno)
        end
      end

      def roll_back_database_migrations(remote_host)
        if migration_count > 0
          dyno = api.dyno.create(app_name, command: "rake db:rollback STEP=#{migration_count}")
          poll_one_off_dyno_until_done(dyno)
        end
      end

    private

      def api
        @api ||= begin
          begin
            PlatformAPI.connect_oauth(api_token)
          rescue Excon::Errors::Unauthorized
            raise ConfigError, "Access to Heroku app denied"
          end
        end
      end

      def app
        @app ||= api.app.info(app_name)
      end

      def migration_count
        @migration_count || 0
      end

      def process_counts
        @process_counts ||= begin
          formations = api.formation.list(app_name).each_with_object({}) { |f, m| m[f['type'].to_sym] = f }
          formations.each_with_object({}) do |(process_type, info), m|
            m[process_type] = info.fetch('quantity', 0)
          end
        end
      end

      def poll_one_off_dyno_until_done(dyno)
        done = false
        state = 'starting'
        while !done do
          begin
            dyno = api.dyno.info(app_name, dyno['id'])
            state = dyno['state'] if dyno['state'] != state
            sleep 1
          rescue Excon::Errors::NotFound
            done = true
          end
        end
      end
    end
  end
end
