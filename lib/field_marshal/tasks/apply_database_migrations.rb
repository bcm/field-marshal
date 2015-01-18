module FieldMarshal
  module Tasks
    class ApplyDatabaseMigrations < Task
      def run(remote_host)
        deployer.apply_database_migrations(remote_host)
      end

      def rollback(remote_host)
        deployer.roll_back_database_migrations(remote_host)
      end

      def desc
        "Apply pending database migrations"
      end
    end
  end
end
