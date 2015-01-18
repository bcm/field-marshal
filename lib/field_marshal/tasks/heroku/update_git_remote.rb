module FieldMarshal
  module Tasks
    module Heroku
      class UpdateGitRemote < Task
        attribute :app_name, String

        def run(runner)
          begin
            runner.exec("git remote | grep #{remote_name}")
          #rescue TaskRunner::TaskFailure
            # XXX: heroku_app
          #  runner.exec("git remote add #{remote_name} #{heroku_app['git_url']}")
          end
          runner.exec("get fetch #{remote_name}")
        end

        def remote_name
          @remote_name ||= app_name
        end

        def desc
          "Update Heroku git repo (remote #{remote_name})"
        end
      end
    end
  end
end
