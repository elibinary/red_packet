redis_conf = if Rails.env.production?
      { host: '127.0.0.1', port: 6379 }
    elsif Rails.env.qa?
      { host: '127.0.0.1', port: 6379 }
    else
      { host: '127.0.0.1', port: 6379 }
    end

Redis.current = Redis.new(redis_conf)