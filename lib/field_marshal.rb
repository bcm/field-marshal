module FieldMarshal
  autoload :CLI,                            'field_marshal/cli'
  autoload :RemoteHost,                     'field_marshal/remote_host'
  autoload :Task,                           'field_marshal/task'
  autoload :TaskRunner,                     'field_marshal/task_runner'
  autoload :TaskSpec,                       'field_marshal/task_spec'

  module Deployers
    autoload :Heroku,                       'field_marshal/deployers/heroku'
  end

  module Tasks
    autoload :CloneGitRepo,                 'field_marshal/tasks/clone_git_repo'
    autoload :DetectPendingRailsMigrations, 'field_marshal/tasks/detect_pending_rails_migrations'
    autoload :PushToGitRemote,              'field_marshal/tasks/push_to_git_remote'
    autoload :ScaleDown,                    'field_marshal/tasks/scale_down'
    autoload :TurnOnMaintenanceMode,        'field_marshal/tasks/turn_on_maintenance_mode'
    autoload :UpdateGitRemote,              'field_marshal/tasks/update_git_remote'
  end
end
