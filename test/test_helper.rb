require "rails"

module TestApp
  class Application < ::Rails::Application
    config.secret_key_base = "abc123"

    # avoid warnings
    config.eager_load = false
    config.active_support.test_order = :random
  end
end

TestApp::Application.initialize!

require "rails/test_help"
require "minitest/rails"

require "minime"
# require "byebug"
