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
    :gt5_attribute,
    :lte9_attribute

  validates :required_attribute, presence: true
  validates :confirmable_attribute, confirmation: true

  validates :closed_list_attribute, inclusion: { in: 'a'..'c' }

  validates :gt5_attribute, numericality: { greater_than: 5 }
  validates :lte9_attribute, numericality: { less_than_or_equal_to: 9 }
end

class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers

  private
  def deny_access
    redirect_to :root, alert: 'Access denied'
  end
end

class ModelsController < ApplicationController
  def valid
    @valid_model = Model
      .new required_attribute: 'foo',
        closed_list_attribute: 'a',
        gt5_attribute: 5.01,
        lte9_attribute: 8.99

    head :ok
  end
end

class ProtectedResourcesController < ApplicationController
  before_action :deny_access

  def index   ; end
  def new     ; end
  def create  ; end
  def show    ; end
  def edit    ; end
  def update  ; end
  def destroy ; end
end

class ProtectedSingularResourcesController < ApplicationController
  before_action :deny_access

  def new     ; end
  def create  ; end
  def show    ; end
  def edit    ; end
  def update  ; end
  def destroy ; end
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
  root to: 'models#valid'

  get 'valid', to: 'models#valid'

  resources :protected_resources
  resource :protected_singular_resource
end

require "minitest/rails"

require "minime"
# require "byebug"
