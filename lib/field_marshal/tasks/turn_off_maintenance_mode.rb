module FieldMarshal
  module Tasks
    class TurnOffMaintenanceMode < Task
      def run(remote_host)
        deployer.turn_off_maintenance_mode(remote_host)
      end

      def desc
        "Turn off maintenance mode"
      end
    end
  end
end
