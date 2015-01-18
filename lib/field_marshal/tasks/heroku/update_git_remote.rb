module FieldMarshal
  module Tasks
    module Heroku
      class UpdateGitRemote < Task
        def run(runner)
          begin
            runner.exec("cd #{config.working_dir}; git remote | grep #{remote_name}")
          rescue TaskRunner::TaskFailure => e
            raise e if e.status > 1
            runner.exec("cd #{config.working_dir}; git remote add #{remote_name} #{config.heroku.app['git_url']}")
          end
          runner.exec("cd #{config.working_dir}; git fetch #{remote_name}")
        end

        def remote_name
          @remote_name ||= config.heroku.app_name
        end

        def desc
          "Update Heroku git repo (remote #{remote_name})"
        end
      end
    end
  end
end
