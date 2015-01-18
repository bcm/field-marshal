require 'active_support/core_ext/string/inflections'
require 'virtus'
require 'yaml'

module FieldMarshal
  class TaskSpec
    include Virtus.value_object(strict: true)

    class Config
      include Virtus.value_object(strict: true)

      attribute :host,    String
      attribute :key,     String
      attribute :git_url, String
      attribute :heroku,  Deployers::Heroku

      def working_dir
        @working_dir ||= git_url.split('/').pop
      end
    end

    attribute :config, Config
    attribute :tasks,  Array[Task]

    def self.load(path)
      yaml = YAML.load_file(path)
      config = Config.new(yaml['config'])
      tasks = yaml['tasks'].map { |t| "field_marshal/tasks/#{t}".camelize.constantize.new(config: config) }
      new(config: config, tasks: tasks)
    end

    class ConfigError < StandardError; end
  end
end
