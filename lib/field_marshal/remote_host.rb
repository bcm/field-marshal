require 'net/ssh'
require 'virtus'

module FieldMarshal
  class RemoteHost
    include Virtus.value_object(strict: true)

    attribute :host, String
    attribute :user, String, default: 'ec2-user'
    attribute :key,  String
    attribute :ssh,  Net::SSH

    def connect(&block)
      Net::SSH.start(host, user, keys: [key]) do |ssh|
        self.ssh = ssh
        yield
      end
    end

    def exec(command, &block)
      block = Proc.new do |chan|
        chan.exec(command) do |ch, success|
          raise ExecUnsuccessful unless success

          ch.on_data do |c, data|
            $stdout.print "    #{data}"
            yield(c, data) if block_given?
          end

          ch.on_extended_data do |c, type, data|
            $stderr.print "    #{data}"
          end

          ch.on_request "exit-status" do |c, data|
            status = data.read_long
            raise ExecFailure.new(status) if status > 0
          end
        end
      end
      $stdout.puts "  #{command}"
      ssh.open_channel(&block).tap do |channel|
        channel.wait
      end
    end

    class ExecError < StandardError; end

    class ExecUnsuccessful < ExecError; end

    class ExecFailure < ExecError
      attr_reader :status

      def initialize(status)
        @status = status
        super("Exec failed with status #{status}")
      end
    end
  end
end
