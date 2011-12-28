set :application, 'argo'
set :repository, 'git@github.com:ArgoNavisDev/menu.git' 

server 'argo', :app, :web, :db, :primary => true

set :scm, :git
set :branch, 'dev'
set :user, 'wtn'
set :deploy_to, "~/apps/#{application}"
ssh_options[:forward_agent] = true
set :use_sudo, false
default_run_options[:pty] = true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(release_path, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :install, :roles => :app do
    run "cd #{release_path} && bundle install"

    on_rollback do
      if previous_release
        run "cd #{previous_release} && bundle install"
      else
        logger.important "no previous release to rollback to, rollback of bundler:install skipped"
      end
    end
  end

  task :bundle_new_release, :roles => :db do
    bundler.create_symlink
    bundler.install
  end
end

after 'deploy:rollback:revision', 'bundler:install'
after 'deploy:update_code', 'bundler:bundle_new_release'
