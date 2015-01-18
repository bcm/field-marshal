module FieldMarshal
  module Tasks
    class CloneGitRepo < Task
      attribute :url,    String
      attribute :branch, String, default: 'master'

      def run(runner)
        # XXX: get the remote git repo's ssh key onto the server
        runner.exec("if [ ! -d #{working_dir} ]; then git clone #{url}; fi")
        runner.exec("cd #{working_dir}")
      end

      def working_dir
        @working_dir ||= url.split('/').pop
      end

      def desc
        "Clone git repo at #{url}"
      end
    end
  end
end
