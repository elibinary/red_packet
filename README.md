# README

## Base

* ruby 2.4.0, rails 5.1.4

## Dependencies

* MySQL, Redis, Sidekiq

## Run

```
reids: 127.0.0.1:6379
```

## Test

```
RAILS_ENV = test 
redis: 127.0.0.1:6999

bundle exec rake test
```
Be careful！ Redis will be flush!

## API

Your can generate test user

```ruby
rake generate_data:users
```

* 查看个人余额 (GET /wallets)
* 发红包 (POST /red_bags)
* 抢红包 (GET /red_bags/grab)
* 用户抢到的红包列表 (GET /red_bags)
