# config valid only for Capistrano 3.1
lock '3.2.1'

server '162.243.222.107', roles: [:app, :web, :db], primary: true
application = 'active-accounting2'

set :application, application
set :repo_url, 'git@github.com:activebridge/active-accounting.git'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :rvm_type, :user
set :rvm_ruby_version, '2.0.0'
set :default_shell, '/bin/bash -l'
set :keep_releases, 2
set :branch, 'master'
set :pty, true
set :use_sudo, false

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :db do
  desc "Create database and database user"
  task :create_mysql_database do
    ask :db_root_password, ''
    ask :db_name, "active_accounting_production2"
    ask :db_user, 'root'
    ask :db_pass, ''

    on primary fetch(:migration_role) do
      execute "mysql --user=root --password=#{fetch(:db_root_password)} -e \"CREATE DATABASE IF NOT EXISTS #{fetch(:db_name)}\""
      execute "mysql --user=root --password=#{fetch(:db_root_password)} -e \"GRANT ALL PRIVILEGES ON #{fetch(:db_name)}.* TO '#{fetch(:db_user)}'@'localhost' IDENTIFIED BY '#{fetch(:db_pass)}' WITH GRANT OPTION\""
    end
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
      end
    end
  end

  before "deploy", "deploy:check_revision"
end
