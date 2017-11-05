class RefundRedWorker
  include Sidekiq::Worker

  def perform(red_bag_id)
    red_bag = RedBag.find_by(id: red_bag_id)
    return unless red_bag
    return unless red_bag.state.normal?

    # if (Time.now - red_bag.created_at) / 1.hour >= 24
    if (Time.now - red_bag.created_at) / 1.minutes >= 2
      redis_key = RedBag.build_redis_key(red_bag_id)
      lock = Redis::Lock.new("#{redis_key}:lock")
      lock.lock do
        red_hash = Redis::HashKey.new("#{redis_key}:hash_key")
        total_win = red_hash.all.map { |k, v| v }.inject(0) { |sum, n| sum + BigDecimal.new(n) }
        db_win = red_bag.red_bag_items.sum(:money)

        win = total_win >= db_win ? total_win : db_win
        red_bag.state = 'refunded'
        red_bag.balance = red_bag.money - win

        if RefundToCardService.call(user: red_bag.user, red_bag: red_bag, money: red_bag.balance)
          red_bag.save
        end
      end
    end
  end
end
