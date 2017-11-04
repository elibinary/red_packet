require 'test_helper'

class WalletFlowTest < ActiveSupport::TestCase
  def setup
    @user = create :user
    @wallet = create :wallet, user: @user
  end

  test 'private method ensure_transaction_num should return string' do
    wallet_flow = create :wallet_flow, wallet: @wallet, transaction_num: ''
    wallet_flow.send(:ensure_transaction_num)
    assert wallet_flow.transaction_num.present?
  end
end
