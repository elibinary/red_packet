class RedBag < ApplicationRecord
  extend Enumerize

  include Redis::Objects

  belongs_to :user
  has_many :red_bag_items

  enumerize :state, in: { normal: 1, empty: 2, refunded: 3 }, default: :normal, scope: true

  after_commit :set_redis_info, :set_refund_job, on: :create

  # counter :remaining_number

  def safe_code
    DecimalConverter.decimal_to_sexagesimal(id)
  end

  class << self
    def fetch_by_code(code)
      find_by(id: DecimalConverter.sexagesimal_to_decimal(code))
    end

    def cal_id_by_code(code)
      DecimalConverter.sexagesimal_to_decimal(code)
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
          bag_val.value = { user_id: red_bag.user_id, money: red_bag.money, balance: red_bag.balance, token: red_bag.token, numbers: red_bag.numbers }
          return red_bag.token == token
        else
          false
        end
      end
    end

    def drop_money(user, money, numbers)
      params = {
        user: user,
        money: money,
        balance: money,
        numbers: numbers,
        token: generate_token
      }

      create(params)
    end

    def details_by_code(code)
      id = cal_id_by_code(code)
      key = build_redis_key(id)
      counter = Redis::Counter.new("#{key}:counter")
      Rails.cache.fetch("red:bag:details:#{id}:#{counter.value}") do
        red_info = red_info(id)
        if red_info
          red_info[:items] = red_item_info(id)
        end
        red_info
      end
    end

    def red_info(id)
      Rails.cache.fetch("red:bag:info:#{id}") do
        bag_value = Redis::Value.new("#{build_redis_key(id)}:value", marshal: true)
        if bag_value.value.present?
          bag = bag_value.value
          user = User.find_by(id: bag[:user_id])
          {
            user_name: user.nickname,
            avatar_url: user.avatar_url,
            total_money: bag[:money],
            total_numbers: bag[:numbers]
          }
        elsif red_bag = find_by(id: id)
          {
            user_name: red_bag.user.nickname,
            avatar_url: red_bag.user.avatar_url,
            total_money: red_bag.money,
            total_numbers: red_bag.numbers
          }
        else
          nil
        end
      end
    end

    def red_item_info(id)
      hash = Redis::HashKey.new("#{build_redis_key(id)}:hash_key")
      if hash.all.present?
        user_ids = hash.all.keys

        User.where(id: user_ids).map do |user|
          {
            user_name: user.nickname,
            avatar_url: user.avatar_url,
            money: hash[user.id.to_s]
          }
        end
      else
        RedBagItem.includes(:user).where(red_bag_id: id).map do |item|
          {
            user_name: item.user.nickname,
            avatar_url: item.user.avatar_url,
            money: item.money
          }
        end
      end
    end

    def grab_reds(user)
      RedBagItem.includes(:red_bag).where(user_id: user.id).map do |item|
        {
          red_code: item.red_bag.safe_code,
          total_money: item.red_bag.money,
          money: item.money
        }
      end
    end

    # range: '11111111' ~ 'ZZZZZZZZ'
    def generate_token
      DecimalConverter.decimal_to_sexagesimal(Random.new.rand(2846806779661..167961599999999))
    end
  end

  private

  def set_redis_info
    counter = Redis::Counter.new("#{redis_key}:counter")
    counter.value = numbers

    # { user_id: money }
    Redis::HashKey.new("#{redis_key}:hash_key")

    # { user_id: 1, money: 1, balance: 1, token: 'xxx' }
    bag_value = Redis::Value.new("#{redis_key}:value", marshal: true, expiration: 48.hours)
    bag_value.value ||= { user_id: user_id, money: money, balance: balance, token: token, numbers: numbers }
  end

  def redis_key
    "red:red_bag:#{id}"
  end

  def set_refund_job
    RefundRedWorker.perform_at(5.minutes.from_now, id)
  end
end
