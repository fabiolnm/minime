require "rails"

module TestApp
  class Application < ::Rails::Application
    config.secret_key_base = "abc123"

    # avoid warnings
    config.eager_load = false
    config.active_support.test_order = :random
  end
end

require 'active_model'

class Model
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :required_attribute

  validates :required_attribute, presence: true
end

TestApp::Application.initialize!

require "rails/test_help"
require "minitest/rails"

require "minime"
# require "byebug"
