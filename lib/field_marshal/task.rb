require 'virtus'

module FieldMarshal
  class Task
    include Virtus.value_object(strict: true)

    attribute :config, TaskSpec::Config
  end
end
