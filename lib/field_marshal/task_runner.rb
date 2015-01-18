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
          $stdout.puts "#{i}: #{task.desc}"
          task.run(self)
        end
      end
    end

    def exec(command)
      $stdout.puts "  #{command}"
      @ssh.open_channel do |channel|
        channel.exec(command) do |ch, success|
          raise TaskUnsuccessful unless success

          ch.on_data do |c, data|
            $stdout.print "    #{data}"
          end

          ch.on_extended_data do |c, type, data|
            $stderr.print "    #{data}"
          end

          ch.on_request "exit-status" do |c, data|
            raise TaskFailure if data.read_long > 0
          end
        end
      end.wait
    end

    class TaskError < StandardError; end
    class TaskUnsuccessful < TaskError; end
    class TaskFailure < TaskError; end
  end
end
