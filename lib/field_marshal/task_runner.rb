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
        ssh.open_channel do |channel|
          tasks.each do |task|
            rv = task.run(channel)
            unless rv
              $stderr.puts "task failed; breaking out of sequence"
              break
            end
          end
        end
      end
    end
  end
end
