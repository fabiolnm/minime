require_relative '../../test_helper'

describe ModelsController do
  it "validates valid assigns" do
    get :valid
    must_assign_valid :valid_model
    @valid_model.wont_be_nil
  end
end

describe ProtectedResourcesController do
  it "forbids access to resources" do
    must_protect_actions redirecting_to: :root, alert: 'Access denied'
  end
end

describe ProtectedSingularResourcesController do
  it "forbids access to resources" do
    must_protect_actions singular: true,
      redirecting_to: :root, alert: 'Access denied'
  end
end
