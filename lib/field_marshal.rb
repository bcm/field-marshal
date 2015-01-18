module FieldMarshal
  autoload :CLI,                 'field_marshal/cli'
  autoload :Task,                'field_marshal/task'
  autoload :TaskRunner,          'field_marshal/task_runner'
  autoload :TaskSpec,            'field_marshal/task_spec'

  module Tasks
    autoload :Echo,              'field_marshal/tasks/echo'
    autoload :CloneGitRepo,      'field_marshal/tasks/clone_git_repo'

    module Heroku
      autoload :UpdateGitRemote, 'field_marshal/tasks/heroku/update_git_remote'
    end
  end
end
