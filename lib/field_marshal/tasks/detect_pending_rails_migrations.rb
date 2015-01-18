module FieldMarshal
  module Tasks
    class DetectPendingRailsMigrations < Task
      def run(runner)
        cmd = <<-SH
cd #{config.working_dir};
  git diff #{config.git_branch} #{config.git_remote}/master --name-only -- db/migrate | wc -l
SH
        runner.exec(cmd) do |channel, data|
          config.context[:migration_count] = data.strip!.to_i
        end
      end

      def desc
        "Detect pending migrations"
      end
    end
  end
end
