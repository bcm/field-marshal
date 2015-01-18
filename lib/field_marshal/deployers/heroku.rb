require 'excon'
require 'platform-api'

module FieldMarshal
  module Deployers
    class Heroku
      include Virtus.value_object(strict: true)

      attribute :app_name,  String
      attribute :api_token, String

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

      def turn_on_maintenance_mode
        api.app.update(app_name, maintenance: true)
      end

      def turn_off_maintenance_mode
        api.app.update(app_name, maintenance: false)
      end

      def scale_down
        updates = process_counts.each_with_object([]) do |(process_type, count), m|
          m << {'process' => process_type.to_s, 'quantity' => 0} if count > 0
        end
        api.formation.batch_update(app_name, 'updates' => updates)
      end

      def scale_up
        updates = process_counts.each_with_object([]) do |(process_type, count), m|
          m << {'process' => process_type.to_s, 'quantity' => count}
        end
        api.formation.batch_update(app_name, 'updates' => updates)
      end

      def roll_back_to_previous_release
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

      def process_counts
        @process_counts ||= begin
          formations = api.formation.list(app_name).each_with_object({}) { |f, m| m[f['type'].to_sym] = f }
          formations.each_with_object({}) do |(process_type, info), m|
            m[process_type] = info.fetch('quantity', 0)
          end
        end
      end
    end
  end
end
