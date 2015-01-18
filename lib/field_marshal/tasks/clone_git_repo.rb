module FieldMarshal
  module Tasks
    class CloneGitRepo < Task
      def run(runner)
        # XXX: get the remote git repo's ssh key onto the server
        runner.exec("if [ ! -d #{config.working_dir} ]; then git clone #{config.git_url}; fi")
      end

      def desc
        "Clone git repo at #{config.git_url}"
      end
    end
  end
end
