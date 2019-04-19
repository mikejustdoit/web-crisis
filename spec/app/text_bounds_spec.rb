require "text_bounds"

RSpec.describe TextBounds do
  subject(:bounds) { TextBounds.new(x: x, width: width) }
  let(:x) { 5 }
  let(:width) { 1000 }

  it "has a getter for its x position" do
    expect(bounds.x).to eq(x)
  end

  it "has a getter for its width dimension" do
    expect(bounds.width).to eq(width)
  end

  it "has a getter for its right edge" do
    expect(bounds.right).to eq(x + width)
  end

  describe "tracking undefined attributes" do
    context "when both x and width are non-nil" do
      it "considers itself _defined_" do
        expect(bounds).to be_defined
      end
    end

    context "when one or more attribute is nil" do
      let(:width) { nil }

      it "doesn't consider itself _defined_" do
        expect(bounds).not_to be_defined
      end
    end

    context "when one or more attribute hasn't been supplied" do
      subject(:bounds) { TextBounds.new }

      it "doesn't consider itself _defined_" do
        expect(bounds).not_to be_defined
      end
    end
  end

  describe "cloning with different attributes" do
    let(:x) { 0 }
    let(:width) { 2 }

    context "specifying some new attributes" do
      let(:new_x) { 10 }

      before do
        @returned_bounds = bounds.clone_with(x: new_x)
      end

      it "doesn't change the old bounds's attributes" do
        expect(bounds.x).to eq(x)
        expect(bounds.width).to eq(width)
      end

      it "returns a new bounds" do
        expect(@returned_bounds).not_to eql(bounds)
      end

      it "copies over old bounds's other attributes" do
        expect(@returned_bounds.width).to eq(width)
      end

      it "assigns the new attributes to the new bounds" do
        expect(@returned_bounds.x).to eq(new_x)
      end
    end

    context "without specifying any attributes" do
      before do
        @returned_bounds = bounds.clone_with
      end

      it "returns a new bounds" do
        expect(@returned_bounds).not_to eql(bounds)
      end

      it "copies over old bounds's other attributes" do
        expect(@returned_bounds.x).to eq(bounds.x)
        expect(@returned_bounds.width).to eq(bounds.width)
      end
    end
  end

  describe "comparing with other TextBounds" do
    context "when their values of x and width are the same" do
      let(:other_bounds) { bounds.clone_with }

      it "matches the other TextBounds" do
        expect(bounds == other_bounds).to be true
      end
    end

    context "when their values of either x or width are not the same" do
      let(:other_bounds) { bounds.clone_with(x: bounds.x + 1) }

      it "doesn't match the other TextBounds" do
        expect(bounds == other_bounds).to be false
      end
    end
  end
end
