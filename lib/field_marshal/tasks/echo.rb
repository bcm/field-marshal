require 'virtus'

module FieldMarshal
  module Tasks
    class Echo
      include Virtus.value_object(strict: true)

      attribute :input, String

      def run
        puts input
      end
    end
  end
end
