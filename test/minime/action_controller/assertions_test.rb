require_relative '../../test_helper'

describe ModelsController do
  it "validates valid assigns" do
    get :valid
    assert_assigns_valid :valid_model
    assert_not_nil @valid_model
  end
end
