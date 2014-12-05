class ActiveSupport::TestCase
  # Usage:
  #
  # With explicit local object:
  #
  #   it "validates attribute" do
  #     obj = ...
  #     assert_validates_presence_of :attribute, obj
  #   end
  #
  # With explicit subject:
  #
  #   describe "validations" do
  #     subject { ... }
  #
  #     it "validates attribute" do
  #       assert_validates_presence_of :attribute
  #     end
  #   end
  #
  # With implicit subject - determined from "described" subject
  #
  #   describe Model do
  #     it "validates attribute" do
  #       assert_validates_presence_of :attribute
  #     end
  #   end
  #
  def assert_validates_presence_of(attribute, model=nil)
    validating attribute, :blank

    with_subject model
    with({ attribute => nil })
    assert_invalid

    with({ attribute => "" })
    assert_invalid
  end

  def assert_validates_confirmation_of(attribute, model=nil)
    validating "#{attribute}_confirmation", confirmation: { attribute: attribute.to_s.humanize }

    with_subject model
    with({ attribute => '123', "#{attribute}_confirmation" => '456' })
    assert_invalid

    with({ attribute => '123', "#{attribute}_confirmation" => '123' })
    assert_valid
  end

  def validating(attr, opts)
    @attribute  = attr
    @validation = opts
  end

  def with_subject(model)
    @subject = if model.respond_to? :valid?
                 model
               elsif defined?(subject) && subject.respond_to?(:valid?)
                 subject
               else
                 # model is the spec block itself:
                 #
                 # describe Model, :model do
                 #   it {
                 #     # here, self.class.name evals to "Model::model"
                 #     assert_validates_presence_of :attribute
                 #   }
                 # end
                 #
                 self.class.name.gsub(/::model.*/, "").constantize.new
               end
  end

  def with(values)
    @values = values
    values.each {|attr,value| @subject.send "#{attr}=", value }
  end

  def assert_invalid
    @subject.valid?
    errors.must_include error_message, assertion_message
  end

  def assert_valid
    @subject.valid?
    errors.wont_include error_message, assertion_message
  end

  private
  def errors
    @subject.errors.messages[@attribute.to_sym] || []
  end

  # assert_invalid_with { greater_than: { count: value } }
  #
  # or
  #
  # assert_invalid_with :blank
  def error_message
    if @validation.is_a? Hash
      I18n.t "errors.messages.#{@validation.keys.first}", @validation.values.first
    else
      I18n.t "errors.messages.#{@validation}"
    end
  end

  def assertion_message
    message { "validating #{@subject.class.name} with:\n#{attributes_values}" }
  end

  def attributes_values
    @values.map { |attr,val|
      ":#{attr} set to #{val.nil? ? :nil : (val.blank? ? :blank : val)}"
    }.join "\n"
  end
end
