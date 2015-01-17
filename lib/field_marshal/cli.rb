require 'thor'

module FieldMarshal
  class CLI < Thor
    desc 'echo', 'Echo an input string'
    option :host, aliases: :h, required: true
    option :key,  aliases: :k, required: true
    option :user, aliases: :u
    def echo(input)
      task = FieldMarshal::Tasks::Echo.new(input: input)
      runner_options = {host: options[:host]}
      [:key, :user].each do |option|
        runner_options[option] = options[option.to_s] if options.key?(option.to_s)
      end
      TaskRunner.new(runner_options).run(task)
    end
  end
end
