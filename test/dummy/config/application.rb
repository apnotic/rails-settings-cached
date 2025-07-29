require_relative "boot"

require "rails"
require "active_record/railtie"
require "action_controller/railtie"
require "active_storage/engine"

Bundler.require(*Rails.groups)
require "rails-settings-cached"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.cache_store = :memory_store

    # puts "call noconnection: #{NoConnectionSetting.bar}"
  end
end
