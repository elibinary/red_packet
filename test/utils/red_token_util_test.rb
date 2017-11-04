require 'test_helper'

class RedTokenUtilTest < ActiveSupport::TestCase
  test 'encode and decode' do
    token = RedTokenUtil.encode( openid: 'abcdefg')
    assert_not_nil token

    payload = RedTokenUtil.decode token
    assert_equal 'abcdefg', payload['openid']
  end

  test 'decode with wrong args' do
    assert !RedTokenUtil.decode(nil)
    assert !RedTokenUtil.decode('binary')
  end
end