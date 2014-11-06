class ActionController::TestCase
  def assert_assigns_valid(name)
    value = assigns name
    value.must_be :valid?, value.errors.messages
    instance_variable_set "@#{name}", value
  end
end
