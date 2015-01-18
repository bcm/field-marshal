require 'virtus'

module FieldMarshal
  class Task
    include Virtus.value_object(strict: true)

    attribute :config, TaskSpec::Config

    def deployer
      config.deployer
    end
  end
end
