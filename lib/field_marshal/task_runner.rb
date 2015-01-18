require 'net/ssh'
require 'virtus'

module FieldMarshal
  class TaskRunner
    include Virtus.value_object(strict: true)

    attribute :spec, TaskSpec

    def run
      remote_host = RemoteHost.new(spec.config)
      remote_host.connect do
        spec.tasks.each_with_index do |task, i|
          $stdout.puts "#{i+1}: #{task.desc}"
          task.run(remote_host)
        end
      end
    end
  end
end
