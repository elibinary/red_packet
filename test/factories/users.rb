FactoryGirl.define do
  factory :user do
    nickname { SecureRandom.hex(10) }
    user_key { SecureRandom.uuid.gsub('-', '') }
  end
end
