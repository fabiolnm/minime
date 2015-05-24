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

  describe "attribute uniqueness" do
    it "validates explicit local object" do
      assert_validates_uniqueness_of :unique_attribute, Model.new
    end

    it "validates described model" do
      assert_validates_uniqueness_of :unique_attribute
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        assert_validates_uniqueness_of :unique_attribute
      end
    end
  end

  describe "attribute with unique index" do
    it "validates explicit local object" do
      assert_has_unique_index :unique_attribute, Model.new
    end

    it "validates described model" do
      assert_has_unique_index :unique_attribute
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        assert_has_unique_index :unique_attribute
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

  describe "attribute is less than or equal to a value" do
    it "validates explicit local object" do
      assert_validates_numericality_of({ lte9_attribute: { is_less_than_or_equal_to: 9 } }, Model.new)
    end

    it "validates described model" do
      assert_validates_numericality_of lte9_attribute: { is_less_than_or_equal_to: 9 }
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        assert_validates_numericality_of lte9_attribute: { is_less_than_or_equal_to: 9 }
      end
    end
  end

  describe "attribute format" do
    it "validates explicit local object" do
      assert_validates_format_of({
        three_letters_format_attribute: {
          valid_examples: %w{ABC abc Abc 123 A12},
          invalid_examples: %w{ab abcd a@1 12!}
        }
      }, Model.new)
    end

    it "validates described model" do
      assert_validates_format_of three_letters_format_attribute: {
        valid_examples: %w{ABC abc Abc 123 A12},
        invalid_examples: %w{ab abcd a@1 12!}
      }
    end

    describe "explicit subject" do
      subject { Model.new }

      it "validates attribute" do
        assert_validates_format_of three_letters_format_attribute: {
          valid_examples: %w{ABC abc Abc 123 A12},
          invalid_examples: %w{ab abcd a@1 12!}
        }
      end
    end
  end

  describe "attribute length" do
    describe "minimum" do
      it "validates explicit local object" do
        assert_validates_length_of({
          minimum_length_attribute: { minimum: 5 }
        }, Model.new)
      end

      it "validates described model" do
        assert_validates_length_of minimum_length_attribute: { minimum: 5 }
      end

      describe "explicit subject" do
        subject { Model.new }

        it "is validated" do
          assert_validates_length_of minimum_length_attribute: { minimum: 5 }
        end
      end
    end

    describe "maximum" do
      it "validates explicit local object" do
        assert_validates_length_of({
          maximum_length_attribute: { maximum: 5 }
        }, Model.new)
      end

      it "validates described model" do
        assert_validates_length_of maximum_length_attribute: { maximum: 5 }
      end

      describe "explicit subject" do
        subject { Model.new }

        it "is validated" do
          assert_validates_length_of maximum_length_attribute: { maximum: 5 }
        end
      end
    end

    describe "range" do
      describe "in" do
        it "validates explicit local object" do
          assert_validates_length_of({
            range_in_length_attribute: { in: 3..5 }
          }, Model.new)
        end

        it "validates described model" do
          assert_validates_length_of range_in_length_attribute: { in: 3..5 }
        end

        describe "explicit subject" do
          subject { Model.new }

          it "is validated" do
            assert_validates_length_of range_in_length_attribute: { in: 3..5 }
          end
        end
      end

      describe "within" do
        it "validates explicit local object" do
          assert_validates_length_of({
            range_within_length_attribute: { within: 3..5 }
          }, Model.new)
        end

        it "validates described model" do
          assert_validates_length_of range_within_length_attribute: { within: 3..5 }
        end

        describe "explicit subject" do
          subject { Model.new }

          it "is validated" do
            assert_validates_length_of range_within_length_attribute: { within: 3..5 }
          end
        end
      end
    end

    describe "exact" do
      it "validates explicit local object" do
        assert_validates_length_of({ exact_length_attribute: { is: 5 } }, Model.new)
      end

      it "validates described model" do
        assert_validates_length_of exact_length_attribute: { is: 5 }
      end

      describe "explicit subject" do
        subject { Model.new }

        it "is validated" do
          assert_validates_length_of exact_length_attribute: { is: 5 }
        end
      end
    end
  end
end
