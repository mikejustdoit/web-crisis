require "box"

RSpec.describe Box do
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
