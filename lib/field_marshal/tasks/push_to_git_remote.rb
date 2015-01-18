module FieldMarshal
  module Tasks
    class PushToGitRemote < Task
      def run(remote_host)
        remote_host.exec <<-SH
cd #{config.working_dir};
  git push #{config.git_remote} #{config.git_branch}:master
SH
      end

      def rollback(remote_host)
        deployer.roll_back_to_previous_release
      end

      def desc
        "Push to remote git repo at #{config.remote_git_url}"
      end
    end
  end
end
