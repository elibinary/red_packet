require 'test_helper'

class GrabRedBagServiceTest < ActiveSupport::TestCase
  setup do
    money = BigDecimal.new('6.6')
    @user = create :user
    @red_bag = create :red_bag, user: @user, money: money, numbers: 10, balance: money
    @redis_key = RedBag.build_redis_key(@red_bag.id)

    SyncRedBagWorker.stubs(:perform_async)
  end

  test 'call should return wrong token' do
    user = create :user
    res = GrabRedBagService.call(user, @red_bag.safe_code, '1')
    assert_not res[:state]
    assert_equal '口令错误', res[:msg]
  end

  test 'call should return double grab' do
    user = create :user
    red_hash = Redis::HashKey.new("#{@redis_key}:hash_key")
    red_hash[user.id] = BigDecimal.new('0.01')
    res = GrabRedBagService.call(user, @red_bag.safe_code, @red_bag.token)
    assert_not res[:state]
    assert_equal '不可以重复拆红包', res[:msg]
  end

  test 'call should return grab field' do
    user = create :user
    counter = Redis::Counter.new("#{@redis_key}:counter")
    counter.value = 0
    res = GrabRedBagService.call(user, @red_bag.safe_code, @red_bag.token)
    assert_not res[:state]
    assert_equal '红包已被抢光', res[:msg]
  end

  test 'call' do
    res = []
    FactoryGirl.create_list(:user, 20).each do |user|
      res << GrabRedBagService.call(user, @red_bag.safe_code, @red_bag.token)
    end

    state_list = res.map { |r| r[:state] }
    money_list = res.map { |r| r[:win_money] }.compact
    assert_equal 10, state_list.select { |state| state }.count
    assert_equal BigDecimal.new('6.6'), money_list.reduce(:+)
  end
end
