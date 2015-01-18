module FieldMarshal
  autoload :CLI,                        'field_marshal/cli'
  autoload :RemoteHost,                 'field_marshal/remote_host'
  autoload :Task,                       'field_marshal/task'
  autoload :TaskRunner,                 'field_marshal/task_runner'
  autoload :TaskSpec,                   'field_marshal/task_spec'

  module Deployers
    autoload :Heroku,                   'field_marshal/deployers/heroku'
  end

  module Tasks
    autoload :ApplyDatabaseMigrations,  'field_marshal/tasks/apply_database_migrations'
    autoload :CloneGitRepo,             'field_marshal/tasks/clone_git_repo'
    autoload :DeployApplication,        'field_marshal/tasks/deploy_application'
    autoload :DetectDatabaseMigrations, 'field_marshal/tasks/detect_database_migrations'
    autoload :RestartApplication,       'field_marshal/tasks/restart_application'
    autoload :ScaleDown,                'field_marshal/tasks/scale_down'
    autoload :ScaleUp,                  'field_marshal/tasks/scale_up'
    autoload :TurnOnMaintenanceMode,    'field_marshal/tasks/turn_on_maintenance_mode'
    autoload :TurnOffMaintenanceMode,   'field_marshal/tasks/turn_off_maintenance_mode'
    autoload :UpdateGitRemote,          'field_marshal/tasks/update_git_remote'
  end
end
