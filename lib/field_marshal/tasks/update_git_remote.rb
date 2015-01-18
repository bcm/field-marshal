module FieldMarshal
  module Tasks
    class UpdateGitRemote < Task
      def run(remote_host)
        remote_host.exec("cd #{config.working_dir}; git remote | grep #{config.git_remote} > /dev/null; if [ $? == 1 ]; then git remote add #{config.git_remote} #{config.remote_git_url}; fi; git fetch #{config.git_remote}")
      end

      def desc
        "Update remote git repository"
      end
    end
  end
end
