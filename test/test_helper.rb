require "rack/test"
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

require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/minime.sqlite3'

ActiveRecord::Schema.define do
  create_table "models", force: :cascade do |t|
    t.string   "required_attribute"
    t.string   "unique_attribute"
    t.string   "confirmable_attribute"
    t.string   "closed_list_attribute"
    t.decimal  "gt5_attribute"
    t.decimal  "lte9_attribute"
    t.string   "three_letters_format_attribute"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index :models, :unique_attribute, unique: true
end

class Model < ActiveRecord::Base
  validates :required_attribute, presence: true
  validates :unique_attribute, uniqueness: true
  validates :confirmable_attribute, confirmation: true

  validates :closed_list_attribute, inclusion: { in: 'a'..'c' }

  validates :gt5_attribute, numericality: { greater_than: 5 }
  validates :lte9_attribute, numericality: { less_than_or_equal_to: 9 }

  validates :three_letters_format_attribute, format: { with: /\A\w{3}\z/ }
end

# fixture for uniqueness validation test
Model.new(unique_attribute: :unique_value).save! validate: false

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
        lte9_attribute: 8.99,
        three_letters_format_attribute: 'A1b'

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
