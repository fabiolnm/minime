class ActionMailer::TestCase
  include ActionView::Helpers::NumberHelper
  include Rails::Dom::Testing::Assertions

  def assert_mailed(action, mail_spec={})
    email = send_action action

    raise 'mail_spec should not be nil' if mail_spec.nil?

    spec = merge_with_defaults mail_spec

    assert_no_match 'translation missing', spec[:subject],
      'have you forgotten to localize email subject?'

    expected_content_type = spec.delete :content_type

    assert_match expected_content_type, email.content_type, message {
      if expected_content_type == 'multipart/alternative'
        'have you forgotten to provide both html / plain text alternatives?'
      else
        "Expected message with content type #{expected_content_type}, found: #{email.content_type}"
      end
    }

    email_values = {}
    spec.keys.each {|key| email_values[key] = email.send key }

    assert_equal spec, email_values

    if block_given?
      email.deliver_now

      assert_select_email do
        yield
      end
    end
  end

  def assert_plain_content(alternate_fixture=nil)
    deliveries = ActionMailer::Base.deliveries

    raise "No e-mail in delivery list" if deliveries.empty?

    delivery = deliveries.last

    parts = delivery.parts.empty? ? [delivery] : delivery.parts

    plain = parts.detect { |part| part["Content-Type"].to_s =~ /^text\/plain\W/ }

    assert plain, 'Could not find plain email part'

    fixture_name = alternate_fixture || @action_name

    # http://apidock.com/rails/v3.2.8/ActionMailer/TestCase/Behavior/read_fixture
    assert_equal read_fixture(fixture_name).map(&:strip), plain.body.raw_source.lines
  end

  private
  def mailer_class
    self.class.mailer_class
  end

  def mailer_name
    mailer_class.name.underscore.tr '/', '.'
  end

  def send_action(action)
    action_and_args = *action
    @action_name = action_and_args.first.to_s
    raise 'mailer action not specified' if @action_name.blank?

    action_args = action_and_args[1..-1]
    mailer_class.send @action_name, *action_args
  end

  def default_subject
    I18n.t :subject, scope: [ mailer_name, @action_name ]
  end

  def merge_with_defaults(mail_spec)
    spec = spec_defaults

    # array valued attributes
    [:from, :to, :cc, :bcc].each do |attr|
      values = mail_spec[attr]
      spec[attr] = [values].flatten if values.present?
    end

    # single valued attributes
    [:subject, :charset, :content_type].each do |attr|
      value = mail_spec[attr]
      spec[attr] = value if value.present?
    end

    spec
  end

  def spec_defaults
    defaults = self.class.mailer_class.default

    default_charset = defaults[:charset]

    spec = { # defaults
      from:         [ defaults[:from] ],
      to:           [ "to@example.com" ],
      cc:           nil,
      bcc:          nil,
      subject:      default_subject,
      charset:      default_charset,
      content_type: 'text/html'
    }
  end
end
