class DecimalConverter
  SEXAGESIMAL = '0123456789abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ'.freeze

  class << self
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
        char_index = SEXAGESIMAL.index(c)
        return unless char_index

        num += (60 ** current_index) * char_index
        current_index += 1
      end
      num
    end
  end
end