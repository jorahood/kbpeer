require 'deprec'
# cap multistaging support
set :stages, %w(staging prod)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :database_yml_in_scm, true
set :application, "kbpeer"
set :repository, 'svn+ssh://poblano.uits.indiana.edu/srv/svn/kb-support/trunk/kbpeer'
set :deploy_to, "/opt/apps/#{application}"

# ssh keys to be copied to server.
# id_dsa.pub is for connecting from my development machine,
# wl2_rsa.pub is for a connection initiated from my bell account
# (private key is stored at bell:.ssh/wl2_rsa) tunnelling for port 1521 from bell to the server
ssh_options[:keys] = %w(/Users/jorahood/.ssh/kbpeer_rsa)

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
#set :scm, :git

set :ruby_vm_type,      :ree        # :ree, :mri
set :web_server_type,   :apache     # :apache, :nginx
set :app_server_type,   :passenger  # :passenger, :mongrel
set :db_server_type,    :sqlite      # :mysql, :postgresql, :sqlite

# set :packages_for_project, %w(libmagick9-dev imagemagick libfreeimage3) # list of packages to be installed
# set :gems_for_project, %w(rmagick mini_magick image_science) # list of gems to be installed

# If you aren't deploying to /opt/apps/#{application} on the target
# servers (which is the deprec default), you can specify the actual location
# via the :deploy_to variable:
#set :deploy_to, "/opt/apps/#{application}"

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    top.deprec.app.restart
  end
end
