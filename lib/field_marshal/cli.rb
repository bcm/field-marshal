require 'thor'

module FieldMarshal
  class CLI < Thor
    desc 'echo', 'Echo an input string'
    def echo(input)
      task = FieldMarshal::Tasks::Echo.new(input: input)
      TaskRunner.new.run(task)
    end
  end
end
