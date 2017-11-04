FactoryGirl.define do
  factory :wallet_flow do
    money '6.6'
    transaction_num { SecureRandom.hex(10) }
  end
end
