require_relative '../../test_helper'

describe Model, :model do
  it "validates explicit local object" do
    Model.new.must_validate_presence_of :required_attribute
  end

  it "validates described model" do
    must_validate_presence_of :required_attribute
  end

  describe "explicit subject" do
    subject { Model.new }

    it "validates attribute" do
      must_validate_presence_of :required_attribute
    end
  end
end
