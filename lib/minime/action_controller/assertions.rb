class ActionController::TestCase
  def assert_assigns_valid(name, test_context=nil)
    value = assigns name
    value.must_be :valid?, value.errors.full_messages.join(', ')
    instance_variable_set "@#{name}", value
  end
end
