module FieldMarshal
  module Tasks
    class ScaleDown < Task
      def run(remote_host)
        deployer.scale_down(remote_host)
      end

      def rollback(remote_host)
        deployer.scale_up(remote_host)
      end

      def desc
        "Scale down application processes"
      end
    end
  end
end
