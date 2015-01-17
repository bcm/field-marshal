require 'virtus'

module FieldMarshal
  module Tasks
    class Echo
      include Virtus.value_object(strict: true)

      attribute :input, String

      def run(channel)
        channel.exec("echo #{input}") do |ch, success|
          raise "could not execute command" unless success

          ch.on_data do |c, data|
            $stdout.print(data)
          end

          ch.on_extended_data do |c, type, data|
            $stderr.print(data)
          end
        end
      end
    end
  end
end
