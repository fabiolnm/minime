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

    unless @subject.respond_to? "#{attribute}_id"
      with({ attribute => "" })
      assert_invalid
    end
  end

  def assert_validates_uniqueness_of(attribute, model=nil)
    with_subject model
    example = @subject.class.take
    raise "Please provide an example of #{model.model_name} required by uniqueness test" unless example

    value_to_duplicate = example.send attribute

    validating attribute, :taken

    with({ attribute => value_to_duplicate })
    assert_invalid
  end

  def assert_has_unique_index(attribute, model=nil)
    with_subject model
    example = @subject.class.take
    raise "Please provide an example of #{model.model_name} required by unique index test" unless example

    value_to_duplicate = example.send attribute

    assert_raises ActiveRecord::RecordNotUnique, "Attribute '#{attribute}' should have a unique index" do
      @subject.class.new(attribute => value_to_duplicate).save! validate: false
    end
  end

  def assert_validates_confirmation_of(attribute, model=nil)
    with_subject model

    validating "#{attribute}_confirmation", confirmation: {
      attribute: @subject.class.human_attribute_name(attribute)
    }

    with({ attribute => '123', "#{attribute}_confirmation" => '456' })
    assert_invalid

    with({ attribute => '123', "#{attribute}_confirmation" => '123' })
    assert_valid
  end

  def assert_validates_inclusion_of(opts, model=nil)
    assert opts.is_a?(Hash),
      "Inclusion options must be in form { attribute => validation_options }"

    attribute = opts.keys.first
    opts = opts[attribute]

    assert opts[:in].present?, "Missing 'in' assertion option"

    validating attribute, :inclusion

    with_subject model
    with({ attribute => "not_in_list_#{Random.srand}" })
    assert_invalid

    @opt = nil
    inclusion_failure_message = error_message

    refute opts[:in].any? { |opt|
      @opt = opt

      with({ attribute => opt })
      @subject.valid?

      # for valid values, test fails if inclusion_failure_message is detected
      errors.include? inclusion_failure_message
    }, "'#{@opt}' could not be validated in list '#{opts[:in].to_a}'"
  end

  def assert_validates_numericality_of(opts, model=nil)
    assert opts.is_a?(Hash),
      "Numericality options must be in form { attribute => validation_options }"

    attribute = opts.keys.first
    opts = opts[attribute]

    valid_assertions = %w{
      is_a_number is_an_integer id_odd is_even is_equal_to
      is_greater_than is_greater_than_or_equal_to
      is_less_than is_less_than_or_equal_to
    }

    with_subject model

    opts.each do |condition, value|
      raise "Invalid condition: #{condition}. Must be one of #{valid_assertions.join ' '}" unless valid_assertions.include? condition.to_s

      assertion = "assert_validates_attribute_#{condition}"
      raise "Condition #{condition} not supported yet." unless respond_to? assertion, true
      send assertion, attribute, value
    end
  end

  def assert_validates_format_of(opts, model=nil)
    assert opts.is_a?(Hash),
      "Format options must be in form { attribute => { valid_examples: [...], invalid_examples: [...] } }"

    attribute = opts.keys.first
    opts = opts[attribute]

    with_subject model
    validating attribute, :invalid

    (opts[:valid_examples] || []).each do |example|
      with attribute => example
      assert_valid
    end

    (opts[:invalid_examples] || []).each do |example|
      with attribute => example
      assert_invalid
    end
  end

  def assert_validates_length_of(opts, model=nil)
    assert opts.is_a?(Hash),
      "Length options must be in form { attribute => { minimum: value, maximum: value } }"

    attribute = opts.keys.first
    opts = opts[attribute]
    with_subject model

    if range = opts.delete(:in) || opts.delete(:within)
      opts[:minimum] = range.begin
      opts[:maximum] = range.end
    end

    assert_validates_length_examples attribute, opts
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

  def assert_validates_attribute_is_greater_than(attribute, value)
    validating attribute, greater_than: { count: value }
    with attribute => value - 1
    assert_invalid

    with attribute => value
    assert_invalid

    with attribute => value + 1
    assert_valid
  end

  def assert_validates_attribute_is_less_than_or_equal_to(attribute, value)
    validating attribute, less_than_or_equal_to: { count: value }
    with attribute => value + 1
    assert_invalid

    with attribute => value
    assert_valid

    with attribute => value - 1
    assert_valid
  end

  # minimum: 5, maximum: 10, is: 7
  def assert_validates_length_examples(attribute, opts)
    opts.each do |k,v|
      length_validation_examples(k, v).each do |error_key, test_values|
        [test_values[:invalid]].flatten.each do |value|
          validating attribute, error_key => { count: v }
          with attribute => '*' * value
          assert_invalid
        end

        [test_values[:valid]].flatten.each do |value|
          validating @attribute, error_key => { count: v }
          with attribute => '*' * value
          assert_valid
        end
      end
    end
  end

  def length_validation_examples(type, constraint)
    v = constraint
    case type
    when :minimum
      { too_short:     { invalid: v - 1, valid: v } }
    when :maximum
      { too_long:      { invalid: v + 1, valid: v } }
    when :is
      { wrong_length:  { invalid: [ v - 1, v + 1 ], valid: v } }
    else
      raise "Option not recognized: #{type}"
    end
  end
end
