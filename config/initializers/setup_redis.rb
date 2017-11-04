redis_conf = if Rails.env.production?
      { host: '127.0.0.1', port: 6399 }
    elsif Rails.env.development?
      { host: '127.0.0.1', port: 6379 }
    else
      { host: '127.0.0.1', port: 6999 }
    end

Redis.current = Redis.new(redis_conf)