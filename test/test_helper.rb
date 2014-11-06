require "rails"
require "rails/test_help"

require "byebug"

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

class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers
end

class ModelsController < ApplicationController
  def valid
    @valid_model = Model.new required_attribute: 'foo'
    head :ok
  end
end

TestApp::Application.initialize!

TestApp::Application.routes.draw do
  get 'valid', to: 'models#valid'
end

require "minitest/rails"

require "minime"
# require "byebug"
