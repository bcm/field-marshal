module FieldMarshal
  autoload :CLI,        'field_marshal/cli'
  autoload :TaskRunner, 'field_marshal/task_runner'

  module Tasks
    autoload :Echo,     'field_marshal/tasks/echo'
  end
end
