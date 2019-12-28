require "box"
require "element"
require "point"
require "support/shared_examples/node"

RSpec.describe Point do
  describe "creating a point from another object's position" do
    it "copies x and y from the object" do
      source_object = Element.new(box: Box.new(x: 12, y: 34, width: 56, height: 78))
      point = Point.from(source_object)

      expect(point.x).to eq(source_object.x)
      expect(point.y).to eq(source_object.y)
    end
  end

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

  describe "combining Points" do
    subject(:first_point) { Point.new(x: 1, y: 3) }
    subject(:next_point) { Point.new(x: 5, y: 7) }

    let(:combined_point) { first_point + next_point }

    it "returns a new Point" do
      expect(combined_point).not_to eq(first_point)
      expect(combined_point).not_to eq(next_point)
    end

    it "takes the combined x" do
      expect(combined_point.x).to eq(first_point.x + next_point.x)
    end

    it "takes the combined y" do
      expect(combined_point.y).to eq(first_point.y + next_point.y)
    end
  end
end
