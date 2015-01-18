require 'net/ssh'
require 'virtus'

module FieldMarshal
  class TaskRunner
    include Virtus.value_object(strict: true)

    attribute :spec, TaskSpec

    def run
      remote_host = RemoteHost.new(spec.config)
      remote_host.connect do
        succeeded = []
        spec.tasks.each_with_index do |task, i|
          $stdout.puts "=====> #{task.desc}"
          begin
            if task.runnable?
              task.run(remote_host)
            else
              $stdout.puts "...skipping"
            end
            succeeded << task
            $stdout.puts ""
          rescue
            succeeded.reverse.each do |t|
              if t.respond_to?(:rollback) && task.runnable?
                $stdout.puts "Rolling back: #{t.desc}"
                begin
                  t.rollback(remote_host)
                rescue StandardError => e
                  $stderr.puts("ROLLBACK FAILURE! #{e}")
                end
              end
            end
            raise
          end
        end
      end
    end
  end
end
