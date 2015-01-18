module FieldMarshal
  module Tasks
    class ScaleUp < Task
      def run(remote_host)
        deployer.scale_up(remote_host)
      end

      def desc
        "Scale up application processes"
      end
    end
  end
end
