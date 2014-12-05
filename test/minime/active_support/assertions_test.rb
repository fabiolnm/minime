require_relative '../../test_helper'

describe Model, :model do
  describe "attribute presence" do
    it "validates explicit local object" do
      assert_validates_presence_of :required_attribute, Model.new
    end

    it "validates described model" do
      assert_validates_presence_of :required_attribute
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        assert_validates_presence_of :required_attribute
      end
    end
  end
end
