require_relative '../../test_helper'

describe ModelsController do
  it "validates valid assigns" do
    get :valid
    assert_assigns_valid :valid_model
    assert_not_nil @valid_model
  end
end

describe ProtectedResourcesController do
  it "forbids access to resources" do
    assert_protect_actions redirecting_to: :root, alert: 'Access denied'
  end
end

describe ProtectedSingularResourcesController do
  it "forbids access to resources" do
    assert_protect_actions singular: true,
      redirecting_to: :root, alert: 'Access denied'
  end
end
