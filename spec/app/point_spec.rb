require "point"
require "support/shared_examples/node"

RSpec.describe Point do
  describe "it behaving like a value object" do
    let(:point) { Point.new(x: 20, y: 15) }

    context "comparing to another point with different position" do
      let(:other_point) { Point.new(x: 10, y: 10) }

      it "does not equal other point" do
        expect( point == other_point ).not_to be true
      end
    end

    context "comparing to another point with identical position" do
      let(:other_point) { Point.new(x: 20, y: 15) }

      it "does equal other point" do
        expect( point == other_point ).to be true
      end
    end
  end

  describe "cloning" do
    let(:node) { Point.new(x: 20, y: 15) }
    let(:node_specific_attribute) { :x }

    it_behaves_like "a clonable node"
  end
end
