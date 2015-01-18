module FieldMarshal
  module Tasks
    class DetectPendingRailsMigrations < Task
      def run(remote_host)
        cmd = <<-SH
cd #{config.working_dir};
  git diff #{config.git_branch} #{config.git_remote}/master --name-only -- db/migrate | wc -l
SH
        remote_host.exec(cmd) do |channel, data|
          config.context[:migration_count] = data.strip!.to_i
        end
      end

      def desc
        "Detect pending migrations"
      end
    end
  end
end
