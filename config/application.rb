require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(*Rails.groups)

module S2ItDelivery
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    config.active_record.raise_in_transactional_callbacks = true
  end
end
