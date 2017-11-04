require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = create :user
  end

  test 'private method ensure_user_key should set value' do
    @user.user_key = ''
    @user.send(:ensure_user_key)
    assert @user.user_key.present?
  end
end
