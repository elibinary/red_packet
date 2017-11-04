module DecimalConverter
  extend ActiveSupport::Concern

  included do
    SEXAGESIMAL = '0123456789abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ'.freeze
  end

  def decimal_to_sexagesimal(num)
    return SEXAGESIMAL[num] if num < 60
    temp = ''
    n = num
    while n > 0
      temp << SEXAGESIMAL[n % 60]
      n /= 60
    end
    # temp.reverse
    temp
  end

  # str: sexagesimal with reverse
  def sexagesimal_to_decimal(str)
    num = 0
    current_index = 0
    str.each_char do |c|
      num += (60 ** current_index) * SEXAGESIMAL.index(c)
      current_index += 1
    end
    num
  end
end