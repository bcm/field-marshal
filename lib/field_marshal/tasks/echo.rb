module FieldMarshal
  module Tasks
    class Echo < Task
      attribute :input, String

      def run(runner)
        runner.exec("echo #{input}")
      end

      def desc
        "Echo input #{input}"
      end
    end
  end
end
