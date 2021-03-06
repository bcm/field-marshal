module FieldMarshal
  module Tasks
    class TurnOnMaintenanceMode < Task
      def run(remote_host)
        deployer.turn_on_maintenance_mode(remote_host)
      end

      def rollback(remote_host)
        deployer.turn_off_maintenance_mode(remote_host)
      end

      def desc
        "Turn on maintenance mode"
      end
    end
  end
end
