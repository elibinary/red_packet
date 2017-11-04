require 'test_helper'

class RedBagTest < ActiveSupport::TestCase
  def setup
    @user = create :user
    @red_bag = create :red_bag, user: @user
  end

  test 'private method decimal_to_sexagesimal should return sexagesimal with reverse' do
    res = @red_bag.send(:decimal_to_sexagesimal, 666)
    assert_equal '6b', res
  end

  test 'private method sexagesimal_to_decimal should return decimal' do
    res = @red_bag.send(:sexagesimal_to_decimal, '6b')
    assert_equal 666, res
  end

  test 'private set_token should set token' do
    red_bag = create :red_bag, user: @user, token: ''
    red_bag.send(:set_token)
    assert red_bag.token.present?
  end

  test 'safe_code should return code' do
    assert_equal @red_bag.decimal_to_sexagesimal(@red_bag.id), @red_bag.safe_code
  end

  test 'fetch_by_code should return red_bag' do
    res = RedBag.fetch_by_code(@red_bag.safe_code)
    assert res
  end
end
