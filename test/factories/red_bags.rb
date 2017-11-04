FactoryGirl.define do
  factory :red_bag do
    money '6.6'
    balance '6.6'
    numbers '10'
    token { SecureRandom.hex(4) }
  end
end
