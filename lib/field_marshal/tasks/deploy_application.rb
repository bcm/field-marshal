module FieldMarshal
  module Tasks
    class DeployApplication < Task
      def run(remote_host)
        deployer.deploy_application(remote_host)
      end

      def rollback(remote_host)
        deployer.roll_back_to_previous_release(remote_host)
      end

      def desc
        "Deploy the application"
      end
    end
  end
end
