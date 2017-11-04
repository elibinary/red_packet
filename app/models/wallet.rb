class Wallet < ApplicationRecord
  include Redis::Objects

  belongs_to :user
  has_many :wallet_flows

  lock :trade

  def as_simple_json
    as_json(only: [:balance])
  end
end
