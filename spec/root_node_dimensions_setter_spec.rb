require "element"
require "root_node_dimensions_setter"
require "text"

RSpec.describe RootNodeDimensionsSetter do
  let(:root) { Element.new(children: children) }
  let(:children) { [Element.new(children: grandchildren), Element.new] }
  let(:grandchildren) { [Text.new(content: "ABC"), Element.new] }

  let(:layout_visitor) {
    RootNodeDimensionsSetter.new(viewport_width, viewport_height)
  }
  let(:viewport_width) { 640 }
  let(:viewport_height) { 480 }

  describe "layout visitor interface" do
    it "supports Element nodes" do
      expect(layout_visitor).to respond_to(:layout_node)
    end

    it "supports Text nodes" do
      expect(layout_visitor).to respond_to(:layout_text_node)
    end
  end

  describe "not traversing the tree" do
    before do
      allow(root).to receive(:layout).and_call_original

      layout_visitor.visit(root)
    end

    it "sends #layout to root node only" do
      expect(root).to have_received(:layout)
    end
  end

  describe "the returned tree" do
    let(:returned_node) { layout_visitor.visit(root) }

    it "returns a new tree" do
      expect(returned_node).not_to eq(root)
    end

    it "sets the returned root node's dimensions to viewport's" do
      expect(returned_node.box.width).to eq(viewport_width)
      expect(returned_node.box.height).to eq(viewport_height)
    end
  end
end
