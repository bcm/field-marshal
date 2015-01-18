require 'virtus'

module FieldMarshal
  class Task
    include Virtus.value_object(strict: true)
  end
end
