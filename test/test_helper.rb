ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha/setup'
require 'sidekiq/testing'

Sidekiq::Testing.inline!
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...

  @@before_all_run = false

  def setup
    super
    RefundRedWorker.stubs(:perform_at)
  end

  def before_all
    return if @@before_all_run

    puts 'redis clear...'
    Redis.current.flushall

    @@before_all_run = true
  end
end
