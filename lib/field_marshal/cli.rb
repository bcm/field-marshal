require 'thor'

module FieldMarshal
  class CLI < Thor
    desc 'spec PATH', 'Run a sequence of tasks from a task spec'
    def spec(path)
      spec = TaskSpec.load(path)
      runner = TaskRunner.new(spec.config)
      runner.run(spec.tasks)
    rescue TaskRunner::TaskError
      $stderr.puts "FAILED"
    end
  end
end
