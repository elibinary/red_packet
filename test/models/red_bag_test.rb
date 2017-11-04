require 'test_helper'

class RedBagTest < ActiveSupport::TestCase
  def setup
    @user = create :user
    @red_bag = create :red_bag, user: @user
  end

  test 'generate_token should return token' do
    3.times.each do
      assert_equal 8, RedBag.generate_token.length
    end
  end

  test 'safe_code should return code' do
    assert_equal DecimalConverter.decimal_to_sexagesimal(@red_bag.id), @red_bag.safe_code
  end

  test 'fetch_by_code should return red_bag' do
    res = RedBag.fetch_by_code(@red_bag.safe_code)
    assert res
  end

  test 'check_token should return true' do
    assert RedBag.check_token(@red_bag.id, @red_bag.token)
  end

  test 'check_token should return false' do
    assert_not RedBag.check_token(@red_bag.id, '1')
    assert_not RedBag.check_token(0, @red_bag.token)
  end

  test 'cal_id_by_code should return id' do
    code = @red_bag.safe_code
    assert_equal @red_bag.id, RedBag.cal_id_by_code(code)
  end

  test 'drop_money should return instance for RedBag' do
    res = RedBag.drop_money(@user, '3.3', 10)

    assert res
    assert res.instance_of?(RedBag)
  end

  test 'red_item_info should return items array' do
    red_bag = create :red_bag, user: @user
    user = create :user
    item = create :red_bag_item, user: user, red_bag: red_bag, money: '0.01'
    res = RedBag.red_item_info(red_bag.id)
    assert_equal 1, res.size
    assert_equal item.money, res.first[:money]
  end

  test 'red_info should return red info' do
    res = RedBag.red_info(@red_bag.id)
    assert res
    assert_equal @user.nickname, res[:user_name]
    assert_equal @red_bag.numbers, res[:total_numbers]
  end

  test 'details_by_code should return red details' do
    red_bag = create :red_bag, user: @user, numbers: 1
    user = create :user
    item = create :red_bag_item, user: user, red_bag: red_bag, money: '0.01'

    res = RedBag.details_by_code(red_bag.safe_code)
    assert_equal @user.nickname, res[:user_name]
    assert_equal 1, res[:items].size
    assert_equal user.nickname, res[:items].first[:user_name]
  end

  test 'grab_reds should return reds' do
    red_bag = create :red_bag, user: @user, numbers: 1
    user = create :user
    create :red_bag_item, user: user, red_bag: red_bag, money: '0.01'
    res = RedBag.grab_reds(user)
    assert_equal 1, res.count
    assert_equal red_bag.safe_code, res.first[:red_code]
    assert_equal '0.01', res.first[:money].to_s
  end
end
