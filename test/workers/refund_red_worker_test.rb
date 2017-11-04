require 'test_helper'
class RefundRedWorkerTest < ActiveSupport::TestCase
  def setup
    money = BigDecimal.new('6.6')
    @user = create :user
    @red_bag = create :red_bag, user: @user, money: money, numbers: 5, balance: money
  end

  test 'sync red bag' do
    FactoryGirl.create_list(:user, 3).each do |user|
      create :red_bag_item, user: user, red_bag: @red_bag, money: '0.01'
    end
    @red_bag.update(created_at: Time.now - 24.hours)
    RefundRedWorker.new.perform(@red_bag.id)

    @red_bag.reload
    assert_equal @red_bag.money - BigDecimal.new('0.03'), @red_bag.balance
  end
end
