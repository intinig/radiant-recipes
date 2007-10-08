# Keep it _FAST_
set :deploy_via, :remote_cache

# SCM information
set :scm_username, ENV['SCM_USERNAME'] || "intinig"
set :scm_password, Proc.new { CLI.password_prompt "SVN Password: "}

set :rails_version, "stable" # use "edge" if you like bleeding edge

namespace :deploy do
  after "deploy:setup", "deploy:medlar:rails:freezer:#{rails_version}"
  after "deploy:symlink", "deploy:medlar:rails:link"
  
  namespace :medlar do
    
    namespace :rails do

      namespace :freezer do

        desc "Fetch Rails stable and puts it into shared."
        task :stable do
          run "cd #{shared_path}; rm -rf rails; svn co http://svn.rubyonrails.org/rails/branches/1-2-stable rails"
        end

        desc "Fetch Rails edge and puts it into shared."
        task :edge do
          run "cd #{shared_path}; rm -rf rails; svn co http://svn.rubyonrails.org/rails/trunk rails"
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
    
    # Blatantly stolen from: http://errtheblog.com/post/21
    desc "tail production log files" 
    task :tail_logs, :roles => :app do
      run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
        puts  # for an extra line break before the host name
        puts "#{channel[:host]}: #{data}" 
        break if stream == :err    
      end
    end
  end

end
