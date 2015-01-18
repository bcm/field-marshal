module FieldMarshal
  module Tasks
    class CloneGitRepo < Task
      def run(remote_host)
        # XXX: get the remote git repo's ssh key onto the remote host
        remote_host.exec("if [ ! -d #{config.working_dir} ]; then git clone #{config.git_url}; fi")
      end

      def desc
        "Clone application git repository"
      end
    end
  end
end
