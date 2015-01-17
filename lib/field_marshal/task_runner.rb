require 'net/ssh'
require 'virtus'

module FieldMarshal
  class TaskRunner
    include Virtus.value_object(strict: true)

    attribute :host, String
    attribute :user, String, default: 'ec2-user'
    attribute :key,  String

    def run(task)
      Net::SSH.start(host, user, keys: [key]) do |ssh|
        ssh.open_channel do |channel|
          task.run(channel)
        end.wait
      end
    end
  end
end
