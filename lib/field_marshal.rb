module FieldMarshal
  autoload :CLI,                            'field_marshal/cli'
  autoload :Task,                           'field_marshal/task'
  autoload :TaskRunner,                     'field_marshal/task_runner'
  autoload :TaskSpec,                       'field_marshal/task_spec'

  module Deployers
    autoload :Heroku,                       'field_marshal/deployers/heroku'
  end

  module Tasks
    autoload :CloneGitRepo,                 'field_marshal/tasks/clone_git_repo'
    autoload :DetectPendingRailsMigrations, 'field_marshal/tasks/detect_pending_rails_migrations'

    module Heroku
      autoload :UpdateGitRemote,            'field_marshal/tasks/heroku/update_git_remote'
    end
  end
end
