require 'thor'

module FieldMarshal
  class CLI < Thor
    desc 'echo', 'Echo an input string'
    option :host, aliases: :h, required: true
    option :key,  aliases: :k, required: true
    option :user, aliases: :u
    option :num,  aliases: :n, type: :numeric, default: 1
    def echo(input)
      task = Tasks::Echo.new(input: input)
      runner_options = {host: options[:host]}
      [:key, :user].each do |option|
        runner_options[option] = options[option.to_s] if options.key?(option.to_s)
      end
      runner = TaskRunner.new(runner_options)
      (1..options[:num]).each do |n|
        runner.run(task)
      end
    end

    desc 'spec PATH', 'Run a sequence of tasks from a task spec'
    def spec(path)
      spec = TaskSpec.load(path)
      runner = TaskRunner.new(spec.config)
      runner.run(spec.tasks)
    rescue TaskRunner::TaskError
      $stderr.puts "FAILED"
    rescue StandardError => e
      $stderr.puts "ERROR: #{e}"
    end
  end
end
