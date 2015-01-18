module FieldMarshal
  module Tasks
    class RestartApplication < Task
      def run(remote_host)
        deployer.restart_application(remote_host)
      end

      def desc
        "Restart application processes"
      end
    end
  end
end
