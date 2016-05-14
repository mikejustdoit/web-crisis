require "element"
require "root_node_dimensions_setter"
require "support/shared_examples/visitor"
require "text"

RSpec.describe RootNodeDimensionsSetter do
  subject(:visitor) {
    RootNodeDimensionsSetter.new(
      viewport_width: viewport_width,
      viewport_height: viewport_height,
    )
  }
  let(:viewport_width) { 640 }
  let(:viewport_height) { 480 }

  it_behaves_like "a visitor"

  context "with Element root node" do
    let(:root) { Element.new(children: children) }
    let(:children) { [first_child, last_child] }
    let(:first_child) { Element.new(children: grandchildren) }
    let(:last_child) { Element.new }
    let(:grandchildren) { [first_grandchild, last_grandchild] }
    let(:first_grandchild) { Text.new(content: "ABC") }
    let(:last_grandchild) { Element.new }


    describe "not traversing the tree" do
      before do
        allow(first_child).to receive(:accept_visit).and_call_original
        allow(last_child).to receive(:accept_visit).and_call_original
        allow(first_grandchild).to receive(:accept_visit).and_call_original
        allow(last_grandchild).to receive(:accept_visit).and_call_original

        root.accept_visit(visitor)
      end

      it "visits the root node only" do
        expect(first_child).not_to have_received(:accept_visit)
        expect(last_child).not_to have_received(:accept_visit)
        expect(first_grandchild).not_to have_received(:accept_visit)
        expect(last_grandchild).not_to have_received(:accept_visit)
      end
    end

    describe "the returned tree" do
      let(:returned_node) { root.accept_visit(visitor) }

      it "returns a new tree" do
        expect(returned_node).not_to eq(root)
      end

      it "sets the returned root node's dimensions to viewport's" do
        expect(returned_node.box.width).to eq(viewport_width)
        expect(returned_node.box.height).to eq(viewport_height)
      end
    end
  end

  context "with Text root node" do
    let(:root) { Text.new(content: "ABC") }

    describe "the returned tree" do
      let(:returned_node) { root.accept_visit(visitor) }

      it "returns the 'tree' unchanged" do
        expect(returned_node).to eq(root)
      end

      it "doesn't bother changing the root node's dimensions" do
        expect(returned_node.width).to eq(root.width)
        expect(returned_node.height).to eq(root.height)
      end
    end
  end
end
