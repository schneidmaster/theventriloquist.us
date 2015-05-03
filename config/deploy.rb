# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'theventriloquist.us'
set :repo_url, 'git@code.schneidmaster.com:ventriloquist/web.git'

# Default branch is :master
set :branch, 'stable-production'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/srv/www/theventriloquist.us'

# Use custom strategy to update submodules
set :git_strategy, Capistrano::Git::SubmoduleStrategy

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config.js')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('content/files', 'content/images')

namespace :deploy do
  after :finished, :update do
    on roles(:app) do
      with fetch(:git_environmental_variables) do
        within release_path do
          execute :npm, 'install'
          execute :grunt, 'init'
          execute :grunt, 'prod'
        end
      end
    end
  end

  after :update, :restart do
    on roles(:app) do
      execute :mkdir, '-p', release_path.join('tmp')
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
end