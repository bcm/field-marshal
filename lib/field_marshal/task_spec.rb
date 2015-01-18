require 'active_support/core_ext/string/inflections'
require 'virtus'
require 'yaml'

module FieldMarshal
  class TaskSpec
    include Virtus.value_object(strict: true)

    class Config
      include Virtus.value_object(strict: true)

      attribute :host, String
      attribute :key,  String
    end

    attribute :config, Config
    attribute :tasks,  Array[Task]

    def self.load(path)
      yaml = YAML.load_file(path)
      tasks = yaml['tasks'].map do |(class_name, cfg)|
        task_class = "field_marshal/tasks/#{class_name}".camelize.constantize
        task_class.new(cfg)
      end
      new(config: yaml['config'], tasks: tasks)
    end
  end
end
