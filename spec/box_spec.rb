require "box"

RSpec.describe Box do
  describe "its position and dimensions" do
    subject(:box) { Box.new(x, y, width, height) }
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
  end

  describe "it behaving like a value object" do
    let(:box) { Box.new(*box_attributes) }
    let(:box_attributes) { [0, 1, 2, 3] }

    context "comparing to another box with different position and dimensions" do
      let(:other_box) { Box.new(*other_box_attributes) }
      let(:other_box_attributes) { [10, 10, 20, 20] }

      it "does not equal other box" do
        expect( box == other_box ).not_to be true
      end
    end

    context "comparing to another box with identical position and dimensions" do
      let(:other_box) { Box.new(*other_box_attributes) }
      let(:other_box_attributes) { [0, 1, 2, 3] }

      it "does equal other box" do
        expect( box == other_box ).to be true
      end
    end
  end
end
