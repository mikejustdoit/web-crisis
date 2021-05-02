require "box"
require "element"
require "point"

RSpec.describe Box do
  describe "creating a box from another object's position and dimensions" do
    it "copies the lot" do
      source_object = Element.new(box: Box.new(x: 12, y: 34, width: 56, height: 78))
      box = Box.from(source_object)

      expect(box.x).to eq(source_object.x)
      expect(box.y).to eq(source_object.y)
      expect(box.width).to eq(source_object.width)
      expect(box.height).to eq(source_object.height)
    end

    context "when the source object is missing dimension properties" do
      it "builds a point of a box" do
        source_object = Point.new(x: 12, y: 34)
        box = Box.from(source_object)

        expect(box.x).to eq(12)
        expect(box.y).to eq(34)
        expect(box.width).to eq(1)
        expect(box.height).to eq(1)
      end
    end
  end

  describe "its position and dimensions" do
    subject(:box) { Box.new(x: x, y: y, width: width, height: height) }
    let(:x) { 0 }
    let(:y) { 1 }
    let(:width) { 2 }
    let(:height) { 3 }

    it "has a getter for its x position" do
      expect(box.x).to eq(x)
    end

    it "has a getter for its y position" do
      expect(box.y).to eq(y)
    end

    it "has a getter for its width dimension" do
      expect(box.width).to eq(width)
    end

    it "has a getter for its height dimension" do
      expect(box.height).to eq(height)
    end

    describe "calculated attributes" do
      it "has a getter for its right edge" do
        expect(box.right).to eq(x + width)
      end

      it "has a getter for its bottom edge" do
        expect(box.bottom).to eq(y + height)
      end
    end

    describe "tracking undefined attributes" do
      context "when all of x, y, width and height are non-nil" do
        it "considers itself _defined_" do
          expect(box).to be_defined
        end
      end

      context "when one or more attribute is nil" do
        let(:width) { nil }

        it "doesn't consider itself _defined_" do
          expect(box).not_to be_defined
        end
      end

      context "when one or more attribute hasn't been supplied" do
        subject(:box) { Box.new }

        it "doesn't consider itself _defined_" do
          expect(box).not_to be_defined
        end
      end
    end
  end

  describe "comparing position with other objects" do
    let(:box) { Box.new(x: 100, y: 100, width: 600, height: 400) }

    context "when our Box isn't fully defined" do
      let(:box) { Box.new(x: nil, y: 100, width: 600, height: 400) }
      let(:other_box) { Box.new(x: 100, y: 100, width: 600, height: 400) }

      it "isn't considered to overlap either way" do
        expect(box.overlaps?(other_box)).to be false
        expect(other_box.overlaps?(box)).to be false
      end
    end

    context "when the other object isn't fully defined" do
      let(:box) { Box.new(x: 100, y: 100, width: 600, height: 400) }
      let(:other_box) { Box.new(x: nil, y: 100, width: 600, height: 400) }

      it "isn't considered to overlap either way" do
        expect(box.overlaps?(other_box)).to be false
        expect(other_box.overlaps?(box)).to be false
      end
    end

    context "when the other object only has its x and y defined" do
      let(:box) { Box.new(x: 100, y: 100, width: 600, height: 400) }
      let(:overlapping_point) { Point.new(x: 350, y: 250) }
      let(:far_away_point) { Point.new(x: 0, y: 0) }

      it "is treated as a point" do
        expect(box.overlaps?(overlapping_point)).to be true
        expect(box.overlaps?(far_away_point)).to be false
      end
    end

    [
      [
        "when the other object overlaps our Box on the left",
        Box.new(x: 90, y: 200, width: 20, height: 100),
      ],
      [
        "when the other object overlaps our Box on the right",
        Box.new(x: 690, y: 200, width: 20, height: 100),
      ],
      [
        "when the other object overlaps our Box at the top",
        Box.new(x: 200, y: 50, width: 100, height: 100),
      ],
      [
        "when the other object overlaps our Box at the bottom",
        Box.new(x: 200, y: 450, width: 100, height: 100),
      ],
      [
        "when the other object fits within our Box",
        Box.new(x: 200, y: 200, width: 100, height: 100),
      ],
      [
        "when the other object entirely covers our Box",
        Box.new(x: 50, y: 50, width: 700, height: 500),
      ],
    ].each do |name, other_box|
      context name do
        it "overlaps both ways" do
          expect(box.overlaps?(other_box)).to be true
          expect(other_box.overlaps?(box)).to be true
        end
      end
    end

    [
      [
        "when the other object touches our Box on the left",
        Box.new(x: 90, y: 200, width: 10, height: 100),
      ],
      [
        "when the other object touches our Box on the right",
        Box.new(x: 700, y: 200, width: 20, height: 100),
      ],
      [
        "when the other object touches our Box at the top",
        Box.new(x: 200, y: 50, width: 100, height: 50),
      ],
      [
        "when the other object touches our Box at the bottom",
        Box.new(x: 200, y: 500, width: 100, height: 100),
      ],
    ].each do |name, other_box|
      context name do
        it "isn't considered to overlap because right and bottom are +1" do
          expect(box.overlaps?(other_box)).to be false
          expect(other_box.overlaps?(box)).to be false
        end
      end
    end
  end

  describe "it behaving like a value object" do
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

    context "comparing to another box with different position and dimensions" do
      let(:other_box) { Box.new(x: 10, y: 10, width: 20, height: 20) }

      it "does not equal other box" do
        expect( box == other_box ).not_to be true
      end
    end

    context "comparing to another box with identical position and dimensions" do
      let(:other_box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

      it "does equal other box" do
        expect( box == other_box ).to be true
      end
    end
  end

  describe "cloning with different attributes" do
    subject(:box) { Box.new(x: x, y: y, width: width, height: height) }
    let(:x) { 0 }
    let(:y) { 1 }
    let(:width) { 2 }
    let(:height) { 3 }

    context "specifying some new attributes" do
      let(:new_y) { 10 }
      let(:new_width) { 50 }

      before do
        @returned_box = box.clone_with(y: new_y, width: new_width)
      end

      it "doesn't change the old box's attributes" do
        expect(box.x).to eq(x)
        expect(box.y).to eq(y)
        expect(box.width).to eq(width)
        expect(box.height).to eq(height)
      end

      it "returns a new box" do
        expect(@returned_box).not_to eql(box)
      end

      it "copies over old box's other attributes" do
        expect(@returned_box.x).to match(x)
        expect(@returned_box.height).to match(height)
      end

      it "assigns the new attributes to the new box" do
        expect(@returned_box.y).to eq(new_y)
        expect(@returned_box.width).to eq(new_width)
      end
    end

    context "without specifying any attributes" do
      before do
        @returned_box = box.clone_with
      end

      it "returns a new box" do
        expect(@returned_box).not_to eql(box)
      end

      it "copies over old box's other attributes" do
        expect(@returned_box).to eq(box)
      end
    end
  end
end
