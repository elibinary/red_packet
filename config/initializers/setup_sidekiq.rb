redis_url = if Rails.env.production?
      'redis://localhost:6379/0'
    elsif Rails.env.development?
      'redis://localhost:6379/0'
    else
      'redis://localhost:6379/0'
    end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 3
  end

  config.average_scheduled_poll_interval = 5
end

