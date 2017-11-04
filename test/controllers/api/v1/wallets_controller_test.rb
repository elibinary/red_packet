require 'test_helper'

class Api::V1::WalletsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
  end

  test 'get index' do
    token = RedTokenUtil.encode(openid: @user.user_key)
    get '/api/v1/wallets', headers: { 'RED-TOKEN' => token }
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal '0.0', result['balance']
  end
end
