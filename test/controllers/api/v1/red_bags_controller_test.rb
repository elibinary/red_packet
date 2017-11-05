require 'test_helper'

class Api::V1::RedBagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    @red_bag = create :red_bag, user: @user
  end

  test 'post create with bad money' do
    token = RedTokenUtil.encode(openid: @user.user_key)
    post '/api/v1/red_bags', headers: { 'RED-TOKEN' => token }, params: { money: 'ab.c', numbers: 5 }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 0, result['success']
    assert_equal '无效的金额', result['message']
  end

  test 'post create with bad money two' do
    token = RedTokenUtil.encode(openid: @user.user_key)
    post '/api/v1/red_bags', headers: { 'RED-TOKEN' => token }, params: { money: '-5', numbers: 5 }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 0, result['success']
    assert_equal '无效的金额', result['message']
  end

  test 'post create with bad numbers' do
    token = RedTokenUtil.encode(openid: @user.user_key)
    post '/api/v1/red_bags', headers: { 'RED-TOKEN' => token }, params: { money: '6.6', numbers: 0 }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 0, result['success']
    assert_equal '请传递有效的人数', result['message']
  end

  test 'post create should return red_code' do
    token = RedTokenUtil.encode(openid: @user.user_key)
    post '/api/v1/red_bags', headers: { 'RED-TOKEN' => token }, params: { money: '6.6', numbers: 10 }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 1, result['success']
    assert result['red_code']
  end

  test 'get show' do
    token = RedTokenUtil.encode(openid: @user.user_key)
    get "/api/v1/red_bags/#{@red_bag.safe_code}", headers: { 'RED-TOKEN' => token }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal @user.nickname, result['user_name']
  end

  test 'get show with wrong code' do
    token = RedTokenUtil.encode(openid: @user.user_key)
    get "/api/v1/red_bags/zOz", headers: { 'RED-TOKEN' => token }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 0, result['success']
    assert_equal '红包不存在', result['message']
  end

  test 'get index' do
    red_bag = create :red_bag, user: @user, numbers: 1
    user = create :user
    item = create :red_bag_item, user: user, red_bag: red_bag, money: '0.01'

    token = RedTokenUtil.encode(openid: user.user_key)
    get '/api/v1/red_bags', headers: { 'RED-TOKEN' => token }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 1, result['red_bags'].count
    assert_equal red_bag.safe_code, result['red_bags'].first['red_code']
  end

  test 'get grab return fail' do
    GrabRedBagService.any_instance.stubs(:call).returns({ state: false, msg: '红包已被抢光' } )

    token = RedTokenUtil.encode(openid: @user.user_key)
    get '/api/v1/red_bags/grab', headers: { 'RED-TOKEN' => token }, params: { red_code: @red_bag.safe_code, word: @red_bag.token }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 0, result['success']
    assert_equal '红包已被抢光', result['message']
  end

  test 'get grab return money' do
    GrabRedBagService.any_instance.stubs(:call).returns({ state: true, win_money: '3.3' } )

    token = RedTokenUtil.encode(openid: @user.user_key)
    get '/api/v1/red_bags/grab', headers: { 'RED-TOKEN' => token }, params: { red_code: @red_bag.safe_code, word: @red_bag.token }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 1, result['success']
    assert_equal '3.3', result['money']
  end

  test 'get grab with wrong token' do
    GrabRedBagService.any_instance.stubs(:call).returns({ state: true, win_money: '3.3' } )

    token = RedTokenUtil.encode(openid: 'abc')
    get '/api/v1/red_bags/grab', headers: { 'RED-TOKEN' => token }, params: { red_code: @red_bag.safe_code, word: @red_bag.token }
    assert_response 400
    result = JSON.parse(response.body)
    assert_equal 1001, result['error']['code']
  end

  test 'get grab with wrong params' do
    GrabRedBagService.any_instance.stubs(:call).returns({ state: true, win_money: '3.3' } )

    token = RedTokenUtil.encode(openid: @user.user_key)
    get '/api/v1/red_bags/grab', headers: { 'RED-TOKEN' => token }, params: { red_code: @red_bag.safe_code }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal 0, result['success']
    assert_equal '参数错误', result['message']
  end
end