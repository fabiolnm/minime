require_relative '../../test_helper'

describe SimpleMailer do
  it "raises when subject is missing" do
    lambda {
      assert_mailed [:welcome, 'myself']
    }.must_raise Minitest::Assertion, /have you forgotten to localize email subject/
  end

  describe "with proper subject" do
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

  describe "ActionMailer::Base.deliveries state before each test" do
    def backup_and_clear_previous_deliveries
      # emulates state left behind by another test
      assert_mailed [:html_welcome, 'myself'], from: 'self@mini.me', to: 'myself@mini.me' do
        assert ActionMailer::Base.deliveries.count > 0
      end

      # call minime callback
      super
    end

    it "is ensured to be clear" do
      ActionMailer::Base.deliveries.must_be_empty
    end

    teardown do
      assert ActionMailer::Base.deliveries.count > 0
    end
  end
end
