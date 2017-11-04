require 'test_helper'
class SyncRedBagWorkerTest < ActiveSupport::TestCase
  def setup
    money = BigDecimal.new('6.6')
    @user = create :user
    @red_bag = create :red_bag, user: @user, money: money, numbers: 5, balance: money
  end

  test 'sync red bag' do
    current_balance = @user.wallet.balance
    SyncRedBagWorker.new.perform(@user.id, @red_bag.id, BigDecimal.new('3.6'))

    @user.reload
    assert_equal current_balance + BigDecimal.new('3.6'), @user.wallet.balance
    assert_equal BigDecimal.new('3.6'), @user.wallet.wallet_flows.last.money
    assert_equal BigDecimal.new('3.6'), @red_bag.red_bag_items.where(user_id: @user.id).last.money
  end
end
