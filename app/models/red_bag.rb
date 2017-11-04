class RedBag < ApplicationRecord
  extend Enumerize
  include DecimalConverter

  belongs_to :user
  has_many :red_bag_items

  enumerize :state, in: { normal: 1, empty: 2, refunded: 3 }, default: :normal, scope: true

  before_commit :set_token, on: :create

  def safe_code
    decimal_to_sexagesimal(id)
  end

  class << self
    def fetch_by_code(code)
      find_by(id: new.sexagesimal_to_decimal(code))
    end
  end

  private

  # '11111111' ~ 'ZZZZZZZZ'
  def set_token
    prng = Random.new
    self.token = decimal_to_sexagesimal(prng.rand(2846806779661..167961599999999))
  end
end
