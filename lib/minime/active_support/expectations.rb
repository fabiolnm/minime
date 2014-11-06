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
end
