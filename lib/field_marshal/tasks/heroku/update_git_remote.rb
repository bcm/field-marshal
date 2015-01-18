module FieldMarshal
  module Tasks
    module Heroku
      class UpdateGitRemote < Task
        def run(runner)
          runner.exec <<-SH
cd #{config.working_dir};
  git remote | grep #{remote_name} > /dev/null;
  if [ $? == 1 ]; then
    git remote add #{remote_name} #{config.heroku.app['git_url']};
  fi
  git fetch #{remote_name}
SH
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
