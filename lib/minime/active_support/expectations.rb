require 'minitest/spec'

module Minitest::Expectations
  # Usage:
  #
  # With explicit local object:
  #
  #   it "validates attribute" do
  #     obj = ...
  #     obj.must_validate_presence_of :attribute
  #   end
  #
  # With explicit subject:
  #
  #   describe "validations" do
  #     subject { ... }
  #
  #     it { must_validate_presence_of :attribute }
  #   end
  #
  # With implicit subject - determined from "described" subject
  #
  #   describe Model do
  #     it { must_validate_presence_of :attribute }
  #   end
  #
  infect_an_assertion :assert_validates_presence_of, :must_validate_presence_of
  infect_an_assertion :assert_validates_uniqueness_of, :must_validate_uniqueness_of
  infect_an_assertion :assert_has_unique_index, :must_have_unique_index
  infect_an_assertion :assert_validates_confirmation_of, :must_validate_confirmation_of
  infect_an_assertion :assert_validates_inclusion_of, :must_validate_inclusion_of
  infect_an_assertion :assert_validates_numericality_of, :must_validate_numericality_of
  infect_an_assertion :assert_validates_format_of, :must_validate_format_of
  infect_an_assertion :assert_validates_length_of, :must_validate_length_of
end
