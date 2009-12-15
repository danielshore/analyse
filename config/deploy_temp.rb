set :application, "analyse"
set :repository, "." 
set :scm, :none 
set :deploy_via, :copy
set :copy_cache, "/tmp/my-app" 
set :copy_compression,    :gzip

#set :repository,  "set your repository location here"

#set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "ec2-174-129-105-231.compute-1.amazonaws.com"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "db1.c0om0daowkw7.us-east-1.rds.amazonaws.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start {}
#   task :stop {}
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end