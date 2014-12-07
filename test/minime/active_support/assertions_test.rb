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

  describe "attribute confirmation" do
    it "validates explicit local object" do
      assert_validates_confirmation_of :confirmable_attribute, Model.new
    end

    it "validates described model" do
      assert_validates_confirmation_of :confirmable_attribute
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        assert_validates_confirmation_of :confirmable_attribute
      end
    end
  end

  describe "attribute inclusion in a list of values" do
    it "validates explicit local object" do
      assert_validates_inclusion_of({ closed_list_attribute: { in: %w{a b c} } }, Model.new)
    end

    it "validates described model" do
      assert_validates_inclusion_of closed_list_attribute: { in: ['a', 'b', 'c'] }
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        assert_validates_inclusion_of closed_list_attribute: { in: 'a'..'c' }
      end
    end
  end

  describe "attribute is greater than a value" do
    it "validates explicit local object" do
      assert_validates_numericality_of({ gt5_attribute: { is_greater_than: 5 } }, Model.new)
    end

    it "validates described model" do
      assert_validates_numericality_of gt5_attribute: { is_greater_than: 5 }
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        assert_validates_numericality_of gt5_attribute: { is_greater_than: 5 }
      end
    end
  end
end
