require "box"
require "support/shared_examples/node"
require "support/visitor_double"
require "text"

RSpec.describe Text do
  subject(:node) { Text.new(box: box, content: text_content) }
  let(:text_content) { "Tweet of the week" }
  let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

  describe "#content" do
    it "returns the content it was initialised with" do
      expect(node.content).to eq(text_content)
    end
  end

  describe "working with node's box" do
    it_behaves_like "a node with a box"

    describe "creating a new node with new box attributes" do
      let(:new_box_attributes) { {:x => 10, :y => 10, :width => 50, :height => 50} }

      before do
        @returned_node = node.clone_with(new_box_attributes)
      end

      it "copies over old node's other attributes" do
        expect(@returned_node.content).to match(node.content)
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
