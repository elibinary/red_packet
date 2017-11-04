redis_url = if Rails.env.production?
      'redis://localhost:6379/0'
    elsif Rails.env.qa?
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
end
