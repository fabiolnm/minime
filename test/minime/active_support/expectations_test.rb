require_relative '../../test_helper'

describe Model, :model do
  describe "attribute presence" do
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

  describe "attribute uniqueness" do
    it "validates explicit local object" do
      Model.new.must_validate_uniqueness_of :unique_attribute
    end

    it "validates described model" do
      must_validate_uniqueness_of :unique_attribute
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        must_validate_uniqueness_of :unique_attribute
      end
    end
  end

  describe "attribute with unique index" do
    it "validates explicit local object" do
      Model.new.must_have_unique_index :unique_attribute
    end

    it "validates described model" do
      must_have_unique_index :unique_attribute
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        must_have_unique_index :unique_attribute
      end
    end
  end

  describe "attribute confirmation" do
    it "validates explicit local object" do
      Model.new.must_validate_confirmation_of :confirmable_attribute
    end

    it "validates described model" do
      must_validate_confirmation_of :confirmable_attribute
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        must_validate_confirmation_of :confirmable_attribute
      end
    end
  end

  describe "attribute inclusion in a list of values" do
    it "validates explicit local object" do
      Model.new.must_validate_inclusion_of closed_list_attribute: { in: %w{a b c} }
    end

    it "validates described model" do
      must_validate_inclusion_of closed_list_attribute: { in: ['a', 'b', 'c'] }
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        must_validate_inclusion_of closed_list_attribute: { in: 'a'..'c' }
      end
    end
  end

  describe "attribute is greater than a value" do
    it "validates explicit local object" do
      Model.new.must_validate_numericality_of gt5_attribute: { is_greater_than: 5 }
    end

    it "validates described model" do
      must_validate_numericality_of gt5_attribute: { is_greater_than: 5 }
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        must_validate_numericality_of gt5_attribute: { is_greater_than: 5 }
      end
    end
  end

  describe "attribute is less than or equal to a value" do
    it "validates explicit local object" do
      Model.new.must_validate_numericality_of lte9_attribute: { is_less_than_or_equal_to: 9 }
    end

    it "validates described model" do
      must_validate_numericality_of lte9_attribute: { is_less_than_or_equal_to: 9 }
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        must_validate_numericality_of lte9_attribute: { is_less_than_or_equal_to: 9 }
      end
    end
  end

  describe "attribute format" do
    it "validates explicit local object" do
      Model.new.must_validate_format_of three_letters_format_attribute: {
        valid_examples: %w{ABC abc Abc 123 A12},
        invalid_examples: %w{ab abcd a@1 12!}
      }
    end

    it "validates described model" do
      must_validate_format_of three_letters_format_attribute: {
        valid_examples: %w{ABC abc Abc 123 A12},
        invalid_examples: %w{ab abcd a@1 12!}
      }
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        must_validate_format_of three_letters_format_attribute: {
          valid_examples: %w{ABC abc Abc 123 A12},
          invalid_examples: %w{ab abcd a@1 12!}
        }
      end
    end
  end
end
