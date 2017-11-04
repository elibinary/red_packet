class GrabRedBagService
  include Serviceable

  def initialize(user, red_code, token)
    @user = user
    @red_code = red_code
    @red_id = RedBag.cal_id_by_code(@red_code)
    @redis_key = RedBag.build_redis_key(@red_id)
    @token = token
  end

  def call
    # red_bag_cache = Redis::Value.new(redis_key, marshal: true)
    #
    # unless red_bag_cache.value
    #   red_bag = RedBag.find_by(id: @red_id)
    # end
    return { state: false, msg: '口令错误' } unless RedBag.check_token(@red_id, @token)

    red_hash = Redis::HashKey.new("#{@redis_key}:hash_key")

    return { state: false, msg: '不可以重复拆红包' } if red_hash[@user.id].present?

    counter = Redis::Counter.new("#{@redis_key}:counter")

    return { state: false, msg: '红包已被抢光' } if counter.value <= 0
    current_num = counter.decr
    return { state: false, msg: '红包已被抢光' } if current_num < 0

    res = { state: false }
    lock = Redis::Lock.new("#{@redis_key}:lock", expiration: 24.hours)
    lock.lock do
      red_hash = Redis::HashKey.new("#{@redis_key}:hash_key")
      if red_hash[@user.id].present?
        counter.incr
        res[:state] = false
        res[:msg] = '不可以重复拆红包'
      else
        bag_value = Redis::Value.new("#{@redis_key}:value", marshal: true)
        current_bag = bag_value.value
        win_money = cal_money(current_bag[:balance], current_num + 1)
        red_hash[@user.id] = win_money.to_s
        current_bag[:balance] -= win_money
        bag_value.value = current_bag

        # persistence
        SyncRedBagWorker.perform_async(@user.id, @red_id, win_money)

        res[:state] = true
        res[:win_money] = win_money
      end
    end

    res
  end

  private

  def cal_money(money, num)
    return if money * 100 < num
    return money if num == 1
    return BigDecimal.new('0.01') if money * 100 == num

    prng = Random.new
    res = prng.rand(1..(money * 100 * 2 / num).to_i)
    res = BigDecimal.new(res) / 100
    (money - res) * 100 < (num - 1) ? money - BigDecimal.new(num-1) / 100 : res
  end
end