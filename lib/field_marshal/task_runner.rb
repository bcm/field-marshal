require 'active_support/core_ext/array/wrap'
require 'net/ssh'
require 'virtus'

module FieldMarshal
  class TaskRunner
    include Virtus.value_object(strict: true)

    attribute :host, String
    attribute :user, String, default: 'ec2-user'
    attribute :key,  String

    def run(tasks)
      tasks = Array.wrap(tasks).compact
      Net::SSH.start(host, user, keys: [key]) do |ssh|
        @ssh = ssh
        tasks.each_with_index do |task, i|
          $stdout.puts "#{i+1}: #{task.desc}"
          task.run(self)
        end
      end
    end

    def exec(command, &block)
      block = Proc.new do |chan|
        chan.exec(command) do |ch, success|
          raise TaskUnsuccessful unless success

          ch.on_data do |c, data|
            $stdout.print "    #{data}"
            yield(c, data) if block_given?
          end

          ch.on_extended_data do |c, type, data|
            $stderr.print "    #{data}"
          end

          ch.on_request "exit-status" do |c, data|
            status = data.read_long
            raise TaskFailure.new(status) if status > 0
          end
        end
      end
      $stdout.puts "  #{command}"
      @ssh.open_channel(&block).tap do |channel|
        channel.wait
      end
    end

    class TaskError < StandardError; end

    class TaskUnsuccessful < TaskError; end

    class TaskFailure < TaskError
      attr_reader :status

      def initialize(status)
        @status = status
        super("Task failed with status #{status}")
      end
    end
  end
end
