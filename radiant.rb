namespace :deploy do
  after "deploy:cold", "deploy:radiant:bootstrap"
  
  desc "Overridden deploy:cold for Radiant."
  task :cold do
    update
    "radiant:bootstrap"
    start
  end
  
  namespace :radiant do
    desc "Radiant Bootstrap with empty template and default values."
    task :bootstrap do
      rake = fetch(:rake, "rake")
      rails_env = fetch(:rails_env, "production")

      run "cd #{current_release}; #{rake} RAILS_ENV=#{rails_env} ADMIN_NAME=Administrator ADMIN_USERNAME=admin ADMIN_PASSWORD=radiant DATABASE_TEMPLATE=empty.yml OVERWRITE=true db:bootstrap"
    end

    desc "Runs migrations on extensions."
    task :migrate_extensions do
      rake = fetch(:rake, "rake")
      rails_env = fetch(:rails_env, "production")

      run "cd #{current_release}; #{rake} RAILS_ENV=#{rails_env} db:migrate:extensions"
    end
  end  
end
