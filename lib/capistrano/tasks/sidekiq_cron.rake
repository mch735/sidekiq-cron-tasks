namespace :deploy do
  desc "Updates Sidekiq::Cron jobs from configuration file"
  task sidekiq_cron: [:set_rails_env] do
    on fetch(:sidekiq_cron_servers) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "sidekiq_cron:load"
        end
      end
    end
  end
  after "deploy:updated", "deploy:sidekiq_cron"
end

namespace :sidekiq_cron do
  task clear: [:set_rails_env] do
    on fetch(:sidekiq_cron_servers) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "sidekiq_cron:clear"
        end
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :sidekiq_cron_role, fetch(:sidekiq_cron_role, :app)
    set :sidekiq_cron_servers, -> { primary(fetch(:sidekiq_cron_role)) }
  end
end
