redis_config = Rails.application.config_for(:redis)
sidekiq_url = redis_config["url"]

Sidekiq.configure_server do |config|
  config.redis = { url: sidekiq_url, driver: :hiredis }
end
Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_url, driver: :hiredis }
end
