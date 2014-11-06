require_relative '../../test_helper'

describe ModelsController do
  it "validates valid assigns" do
    get :valid
    must_assign_valid :valid_model
    @valid_model.wont_be_nil
  end
end
