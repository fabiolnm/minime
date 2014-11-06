require 'minitest/spec'

module Minitest::Expectations
  #
  #   must_assign_valid :model_name
  #
  # will raise assertion error if assigned variable named model_name
  # is not valid, and the assertion message will print model_name's errors
  #
  # If it's valid, it will set an instance variable with same name,
  # to be available to further assertions
  #
  infect_an_assertion :assert_assigns_valid, :must_assign_valid
end
