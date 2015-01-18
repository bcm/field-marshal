require 'active_support/core_ext/string/inflections'
require 'virtus'
require 'yaml'

module FieldMarshal
  class TaskSpec
    include Virtus.value_object(strict: true)

    class Config
      include Virtus.value_object(strict: true)

      attribute :host,       String
      attribute :key,        String
      attribute :git_url,    String
      attribute :git_branch, String, default: 'master'
      attribute :deploy,     Hash

      def working_dir
        @working_dir ||= git_url.split('/').pop
      end

      def remote_git_url
        @remote_git_url ||= deployer.remote_git_url
      end

      def git_remote
        @git_remote ||= deployer.git_remote
      end

      def deployer
        @deployer ||= case deploy['type']
        when 'heroku'
          Deployers::Heroku.new(deploy.merge(
            git_url:     git_url,
            git_branch:  git_branch,
            working_dir: working_dir
          ))
        when nil
          raise ConfigError, "deploy type not specified"
        else
          raise ConfigError, "unknown deploy type '#{deploy['type']}'"
        end
      end
    end

    attribute :config, Config
    attribute :tasks,  Array[Task]

    def self.load(path)
      yaml = YAML.load_file(path)
      config = Config.new(yaml['config'])
      tasks = yaml['tasks'].map do |t|
        klass = "field_marshal/tasks/#{t['name']}".camelize.constantize
        klass.new(config: config, conditions: {if: t['if'], unless: t['unless']})
      end
      new(config: config, tasks: tasks)
    end

    class ConfigError < StandardError; end
  end
end
