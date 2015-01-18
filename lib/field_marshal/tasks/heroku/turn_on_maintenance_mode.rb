module FieldMarshal
  module Tasks
    module Heroku
      class TurnOnMaintenanceMode < Task
        def run(remote_host)
          if config.context[:migration_count].to_i > 0
            deployer.turn_on_maintenance_mode
          end
        end

        def desc
          "Turn on maintenance mode"
        end
      end
    end
  end
end
