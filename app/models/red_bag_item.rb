class RedBagItem < ApplicationRecord
  belongs_to :red_bag
  belongs_to :user
end
