require 'active_support/hash_with_indifferent_access'
require 'virtus'

module FieldMarshal
  class Task
    include Virtus.value_object(strict: true)

    attribute :config,     TaskSpec::Config
    attribute :conditions, ActiveSupport::HashWithIndifferentAccess

    def deployer
      config.deployer
    end

    def runnable?
      if conditions[:if]
        case conditions[:if].to_sym
        when :pending_migrations
          return deployer.pending_migrations?
        else
          raise "Unknown task if #{self.if}"
        end
      elsif conditions[:unless]
        case conditions[:unless].to_sym
        when :pending_migrations
          return !deployer.pending_migrations?
        else
          raise "Unknown task unless #{self.unless}"
        end
      end
      true
    end
  end
end
