require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RedPacket
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.paths['config/routes.rb'].concat(Dir[config.root.join('config/routes/**/*.rb')])

    config.generators do |g|
      g.assets false
      g.stylesheets false
      g.helper false
      g.fixture_replacement :factory_girl
    end
  end
end
