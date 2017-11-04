namespace :generate_data do
  desc 'generate users'
  task users: :environment do
    5.times.each do
      user = User.create(nickname: SecureRandom.hex(3), user_key: SecureRandom.uuid.gsub('-', ''))
      puts user.as_json
      puts "red_token: #{RedTokenUtil.encode(openid: user.user_key)}"
    end
  end
end