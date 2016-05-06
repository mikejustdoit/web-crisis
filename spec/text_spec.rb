require "box"
require "support/visitor_doubles"
require "text"

RSpec.describe Text do
  subject(:node) { Text.new(box: box, content: text_content) }
  let(:text_content) { "Tweet of the week" }
  let(:box) { Box.new(0, 1, 2, 3) }

  describe "#content" do
    it "returns the content it was initialised with" do
      expect(node.content).to eq(text_content)
    end
  end

  describe "working with node's box" do
    it "allows reading box through getter" do
      expect(node.box).to eq(box)
    end

    describe "creating a new node with a new box" do
      let(:new_box) { Box.new(10, 10, 50, 50) }

      before do
        @returned_node = node.with_box(new_box)
      end

      it "doesn't change the old node's box" do
        expect(node.box).to eq(box)
        expect(node.box).not_to eq(new_box)
      end

      it "returns a new node" do
        expect(@returned_node).not_to eq(node)
      end

      it "assigns the new box to the new node" do
        expect(@returned_node.box).to eq(new_box)
      end
    end
  end

  describe "drawing itself" do
    let(:drawing_visitor) { drawing_visitor_double }

    before do
      node.draw(drawing_visitor)
    end

    it "supplies itself to drawing visitor" do
      expect(drawing_visitor).to have_received(:draw_text).with(node)
    end
  end

  describe "laying itself out" do
    subject(:node) { Text.new(content: text_content) }
    let(:text_content) { "Tweet of the week" }

    let(:layout_visitor) { layout_visitor_double }

    before do
      node.layout(layout_visitor)
    end

    it "supplies itself to layout visitor" do
      expect(layout_visitor).to have_received(:layout_text).with(node)
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
