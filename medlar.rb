# Keep it _FAST_
set :deploy_via, :remote_cache

# SCM information
set :scm_username, "intinig"
set :scm_password, Proc.new { CLI.password_prompt "SVN Password: "}

set :rails_version, "stable" # use "edge" if you like bleeding edge

namespace :deploy do
  after "deploy:setup", "deploy:medlar:rails:freeze:#{rails_version}"
  after "deploy:update", "deploy:medlar:rails:link"
  
  namespace :medlar do
    namespace :rails do
      namespace :freeze do
        desc "Fetch Rails stable and puts it into shared."
        task :stable do
          run "cd #{shared_path}; rm -rf rails; svn co http://svn.rubyonrails.org/rails/branches/1-2-stable rails"
        end

        desc "Fetch Rails edge and puts it into shared."
        task :edge do
          run "cd #{shared_path}; rm -rf rails; svn co http://svn.rubyonrails.org/rails/trunk rails"
        end
      end
    end
    
    desc "Updates the fetched version of rails."
    task :update do
      run "cd #{shared_path}/rails; svn up"
    end
    
    desc "Links Rails to application/vendor"
    task :link do
      run "cd #{current_path}/vendor; rm -rf rails; ln -s #{shared_path}/rails ./rails"
    end
  end
end
