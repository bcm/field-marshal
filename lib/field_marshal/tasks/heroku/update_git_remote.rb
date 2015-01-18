module FieldMarshal
  module Tasks
    module Heroku
      class UpdateGitRemote < Task
        def run(runner)
          runner.exec <<-SH
cd #{config.working_dir};
  git remote | grep #{config.git_remote} > /dev/null;
  if [ $? == 1 ]; then
    git remote add #{config.git_remote} #{config.remote_git_url};
  fi
  git fetch #{config.git_remote}
SH
        end

        def desc
          "Update remote git repo at #{config.remote_git_url}"
        end
      end
    end
  end
end
