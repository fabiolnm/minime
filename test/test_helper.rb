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

  attr_accessor :required_attribute,
    :confirmable_attribute,
    :confirmable_attribute_confirmation,
    :closed_list_attribute,
    :greater_than_five_attribute

  validates :required_attribute, presence: true
  validates :confirmable_attribute, confirmation: true

  validates :closed_list_attribute, inclusion: { in: 'a'..'c' }

  validates :greater_than_five_attribute, numericality: { greater_than: 5 }
end

class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers
end

class ModelsController < ApplicationController
  def valid
    @valid_model = Model
      .new required_attribute: 'foo',
        closed_list_attribute: 'a',
        greater_than_five_attribute: 5.01

    head :ok
  end
end


require "action_mailer/railtie"

class SimpleMailer < ActionMailer::Base
  def welcome(name)
    mail from: 'self@mini.me', to: 'myself@mini.me' do |format|
      format.text { render inline: "I'm talking with #{name}" }
      format.html { render inline: "<h1>I'm talking with #{name}</h1>" }
    end
  end

  def plain_welcome(name)
    mail from: 'self@mini.me', to: 'myself@mini.me' do |format|
      format.text { render inline: "I'm talking with #{name}" }
    end
  end

  def html_welcome(name)
    mail from: 'self@mini.me', to: 'myself@mini.me' do |format|
      format.html { render inline: "<h1>I'm talking with #{name}</h1>" }
    end
  end
end

TestApp::Application.initialize!

I18n.backend.store_translations :en, {
  simple_mailer: {
    welcome: {
      subject: 'Welcome!'
    },
    html_welcome: {
      subject: 'Welcome!'
    },
    plain_welcome: {
      subject: 'Welcome!'
    }
  }
}

TestApp::Application.routes.draw do
  get 'valid', to: 'models#valid'
end

require "minitest/rails"

require "minime"
# require "byebug"
