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
          $stdout.puts "#{i+1}: #{task.desc}"
          begin
            task.run(remote_host)
            succeeded << task
          rescue
            succeeded.reverse.each do |t|
              if t.respond_to?(:rollback)
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
