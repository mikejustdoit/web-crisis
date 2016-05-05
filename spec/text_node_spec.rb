require "box"
require "text_node"

RSpec.describe TextNode do
  subject(:text_node) { TextNode.new(box: box, content: text_content) }
  let(:text_content) { "Tweet of the week" }
  let(:box) { Box.new(0, 1, 2, 3) }

  describe "#content" do
    it "returns the content it was initialised with" do
      expect(text_node.content).to eq(text_content)
    end
  end

  describe "working with node's box" do
    it "allows reading box through getter" do
      expect(text_node.box).to eq(box)
    end

    describe "creating a new node with a new box" do
      let(:new_box) { Box.new(10, 10, 50, 50) }

      before do
        @returned_node = text_node.with_box(new_box)
      end

      it "doesn't change the old node's box" do
        expect(text_node.box).to eq(box)
        expect(text_node.box).not_to eq(new_box)
      end

      it "returns a new node" do
        expect(@returned_node).not_to eq(text_node)
      end

      it "assigns the new box to the new node" do
        expect(@returned_node.box).to eq(new_box)
      end
    end
  end

  describe "drawing its text content" do
    let(:drawing_visitor) { double(:drawing_visitor, :draw_text => nil) }

    before do
      text_node.draw(drawing_visitor)
    end

    it "supplies itself to drawing visitor" do
      expect(drawing_visitor).to have_received(:draw_text).with(text_node)
    end
  end

  describe "laying itself out" do
    subject(:text_node) { TextNode.new(content: text_content) }
    let(:text_content) { "Tweet of the week" }

    let(:layout_visitor) { double(:layout_visitor, :layout_text_node => nil) }

    before do
      text_node.layout(layout_visitor)
    end

    it "supplies itself to layout visitor" do
      expect(layout_visitor).to have_received(:layout_text_node).with(text_node)
    end
  end

  describe "quacking like a Node" do
    it "has a #children method" do
      expect(text_node).to respond_to(:children)
    end

    it "returns an empty array" do
      expect(text_node.children).to eq([])
    end
  end
end
