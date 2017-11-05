require 'test_helper'

class DecimalConverterTest < ActiveSupport::TestCase
  test 'decimal_to_sexagesimal should return sexagesimal with reverse' do
    res = DecimalConverter.decimal_to_sexagesimal(666)
    assert_equal '6b', res
  end

  test 'sexagesimal_to_decimal should return decimal' do
    res = DecimalConverter.sexagesimal_to_decimal('6b')
    assert_equal 666, res
  end

  test 'sexagesimal_to_decimal with wrong params' do
    res = DecimalConverter.sexagesimal_to_decimal('aOc')
    assert_nil res
  end
end