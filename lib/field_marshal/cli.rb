require 'thor'

module FieldMarshal
  class CLI < Thor
    desc 'spec PATH', 'Run a sequence of tasks from a task spec'
    def spec(path)
      TaskRunner.new(spec: TaskSpec.load(path)).run
    end
  end
end
