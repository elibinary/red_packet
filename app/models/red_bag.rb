class RedBag < ApplicationRecord
  extend Enumerize
  include DecimalConverter
  include Redis::Objects

  belongs_to :user
  has_many :red_bag_items

  enumerize :state, in: { normal: 1, empty: 2, refunded: 3 }, default: :normal, scope: true

  before_save :set_token
  after_commit :set_redis_info, :set_refund_job, on: :create

  # counter :remaining_number

  def safe_code
    decimal_to_sexagesimal(id)
  end

  class << self
    def fetch_by_code(code)
      find_by(id: new.sexagesimal_to_decimal(code))
    end

    def cal_id_by_code(code)
      new.sexagesimal_to_decimal(code)
    end

    def build_redis_key(id)
      "red:red_bag:#{id}"
    end

    def check_token(id, token)
      bag_val = Redis::Value.new("#{build_redis_key(id)}:value", marshal: true)
      if bag_val.value
        bag_val.value[:token] == token
      else
        red_bag = RedBag.find_by(id: id)
        if red_bag && red_bag.state.normal?
          bag_val.value = { user_id: red_bag.user_id, money: red_bag.money, balance: red_bag.balance, token: red_bag.token }
          return red_bag.token == token
        else
          false
        end
      end
    end
  end

  private

  # '11111111' ~ 'ZZZZZZZZ'
  def set_token
    prng = Random.new
    self.token ||= decimal_to_sexagesimal(prng.rand(2846806779661..167961599999999))
  end

  def set_redis_info
    counter = Redis::Counter.new("#{redis_key}:counter")
    counter.value = numbers

    # { user_id: money }
    Redis::HashKey.new("#{redis_key}:hash_key")
    # { user_id: 1, money: 1, balance: 1, token: 'xxx' }
    bag_value = Redis::Value.new("#{redis_key}:value", marshal: true, expiration: 48.hours)
    bag_value.value ||= { user_id: user_id, money: money, balance: balance, token: token }
  end

  def redis_key
    "red:red_bag:#{id}"
  end

  def set_refund_job
    RefundRedWorker.perform_at(5.minutes.from_now, id)
  end
end
