# Keep it _FAST_
set :deploy_via, :remote_cache

# SCM information
set :scm_username, "intinig"
set :scm_password, Proc.new { CLI.password_prompt "SVN Password: "}

namespace :deploy do
  after "deploy:setup", "deploy:medlar:freeze_rails"
  after "deploy:update", "deploy:medlar:link_rails"
  
  namespace :medlar do
    desc "Fetch Rails1.2 stable and puts it into shared."
    task :freeze_rails do
      run "cd #{shared_path}; rm -rf rails; svn co http://svn.rubyonrails.org/rails/branches/1-2-stable rails"
    end
    
    desc "Updates Rails1.2 stable to latest version."
    task :update_rails do
      run "cd #{shared_path}/rails; svn up"
    end
    
    desc "Links Rails1.2 to application."
    task :link_rails do
      run "cd #{current_path}/vendor; rm -rf rails; ln -s #{shared_path}/rails ./rails"
    end
  end
end
