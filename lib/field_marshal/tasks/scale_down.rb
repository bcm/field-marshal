module FieldMarshal
  module Tasks
    class ScaleDown < Task
      def run(remote_host)
        if config.context[:migration_count].to_i > 0
          deployer.scale_down
        end
      end

      def rollback(remote_host)
        deployer.scale_up
      end

      def desc
        "Scale down application processes"
      end
    end
  end
end
