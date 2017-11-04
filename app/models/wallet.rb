class Wallet < ApplicationRecord
  include Redis::Objects

  belongs_to :user
  has_many :wallet_flows

  lock :trade
end
