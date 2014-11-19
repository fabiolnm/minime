require_relative '../../test_helper'

describe SimpleMailer do
  it "raises when subject is missing" do
    lambda {
      assert_mailed [:welcome, 'myself']
    }.must_raise Minitest::Assertion, /have you forgotten to localize email subject/
  end

  describe "with proper subject" do
    before do
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
    end

    it "validates multipart email" do
      assert_mailed [:welcome, 'myself'],
        from: 'self@mini.me', to: 'myself@mini.me',
        content_type: 'multipart/alternative' do

        assert_plain_content

        assert_select 'h1', "I'm talking with myself"
      end
    end

    it "validates html email (default spec content type)" do
      assert_mailed [:html_welcome, 'myself'],
        from: 'self@mini.me', to: 'myself@mini.me' do

        assert_select 'h1', "I'm talking with myself"
      end
    end

    it "validates plain email" do
      assert_mailed [:plain_welcome, 'myself'],
        from: 'self@mini.me', to: 'myself@mini.me',
        content_type: 'text/plain' do

        assert_plain_content 'welcome'
      end
    end
  end
end
