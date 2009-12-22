require 'deprec'

set :database_yml_in_scm, false
set :application, "kbpeer"
set :repository, 'svn+ssh://poblano.uits.indiana.edu/srv/svn/kb-support/trunk/kbpeer'
set :deploy_to, "/opt/apps/#{application}"

set :scm, :subversion
set :ruby_vm_type,      :ree        # :ree, :mri
set :web_server_type,   :apache     # :apache, :nginx
set :app_server_type,   :passenger  # :passenger, :mongrel
set :db_server_type,    :mysql      # :mysql, :postgresql, :sqlite

desc "Target the staging server, test-kbpeer.uits.iu.edu, with the next task"
task :staging do
  server "test-kbpeer.uits.iu.edu", :app, :web, :cron, :db, :primary => true
end

desc "Target the production server, kbpeer.uits.iu.edu, with the next task"
task :prod do
  server "kbpeer.uits.iu.edu", :app, :web, :cron, :db, :primary => true
end

# set :packages_for_project, %w(libmagick9-dev imagemagick libfreeimage3) # list of packages to be installed
# set :gems_for_project, %w(rmagick mini_magick image_science) # list of gems to be installed

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    top.deprec.app.restart
  end
end
