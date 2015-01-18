module FieldMarshal
  module Tasks
    class DetectDatabaseMigrations < Task
      def run(remote_host)
        deployer.detect_database_migrations(remote_host)
      end

      def desc
        "Detect pending database migrations"
      end
    end
  end
end
