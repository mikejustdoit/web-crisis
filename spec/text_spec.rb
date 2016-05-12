require "box"
require "support/visitor_double"
require "text"

RSpec.describe Text do
  subject(:node) { Text.new(box: box, content: text_content) }
  let(:text_content) { "Tweet of the week" }
  let(:box) { Box.new(x: x, y: y, width: width, height: height) }
  let(:x) { 0 }
  let(:y) { 1 }
  let(:width) { 2 }
  let(:height) { 3 }

  describe "#content" do
    it "returns the content it was initialised with" do
      expect(node.content).to eq(text_content)
    end
  end

  describe "working with node's box" do
    it "allows reading box through getter" do
      expect(node.box).to eq(box)
    end

    it "exposes delegated getters for box's attributes" do
      expect(node.x).to eq(x)
      expect(node.y).to eq(y)
      expect(node.width).to eq(width)
      expect(node.height).to eq(height)
    end

    describe "creating a new node with new box attributes" do
      let(:new_box) { Box.new(**new_box_attributes) }
      let(:new_box_attributes) { {:x => 10, :y => 10, :width => 50, :height => 50} }

      before do
        @returned_node = node.clone_with(new_box_attributes)
      end

      it "doesn't change the old node's box" do
        expect(node.box).to eq(box)
        expect(node.box).not_to eq(new_box)
      end

      it "returns a new node" do
        expect(@returned_node).not_to eq(node)
      end

      it "copies over old node's other attributes" do
        expect(@returned_node.content).to match(node.content)
      end

      it "assigns the new node a new box with the specified attributes" do
        expect(@returned_node.box).to eq(new_box)
      end
    end
  end

  describe "accepting visitors" do
    let(:visitor) { visitor_double }

    before do
      node.accept_visit(visitor)
    end

    it "supplies itself to the visitor's callback" do
      expect(visitor).to have_received(:visit_text).with(node)
    end
  end

  describe "quacking like an Element" do
    it "has a #children method" do
      expect(node).to respond_to(:children)
    end

    it "returns an empty array" do
      expect(node.children).to eq([])
    end
  end
end
