# Necessary to run on Site5
set :use_sudo, false
set :group_writable, false

# Less releases, less space wasted
set :keep_releases, 2

namespace :deploy do
  after "deploy:update", "deploy:site5:link_public_html"
    
  desc <<-DESC
    Site5 version of restart task.
  DESC
  task :restart do
    site5::kill_dispatch_fcgi
  end
  
  namespace :site5 do
    desc <<-DESC
      Links public_html to current_path/public
    DESC
    task :link_public_html do
      run "cd /home/#{user}; rm -rf public_html; ln -s #{current_path}/public ./public_html"
    end
    
    desc <<-DESC
      Kills Ruby instances on Site5
    DESC
    task :kill_dispatch_fcgi do
      run "skill -u #{user} -c dispatch.fcgi"
    end
  end
end