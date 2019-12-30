require "element"
require "node_within_parent"
require "support/shared_examples/node_decorator"
require "text_bounds"

RSpec.describe NodeWithinParent do
  describe "decorating" do
    subject(:node) { NodeWithinParent.new(internal_node, Element.new) }
    let(:internal_node) { Element.new }

    it_behaves_like "a valid node decorator"
  end

  describe "node's maximum bounds" do
    subject(:node_within_parent) { NodeWithinParent.new(node, parent) }

    context "when node's bounds are sufficiently defined" do
      let(:node) { double(:node, :maximum_bounds => nodes_maximum_bounds) }
      let(:nodes_maximum_bounds) { TextBounds.new(x: 10, width: 20) }
      let(:parent) { double(:parent) }

      it "uses the node's own maximum bounds" do
        expect(node_within_parent.maximum_bounds).to eq(nodes_maximum_bounds)
      end
    end

    context "when node's bounds aren't sufficiently defined" do
      let(:node) { double(:node, :x => 10, maximum_bounds: nodes_maximum_bounds) }
      let(:nodes_maximum_bounds) { double(:bounds, :defined? => false) }
      let(:parent) {
        double(:parent, :maximum_bounds => TextBounds.new(x: 50, width: 100))
      }

      it "uses the node's x relative to its parent's bounds' x" do
        expect(node_within_parent.maximum_bounds.x).to eq(40)
      end

      it "uses the parent's bounds' width" do
        expect(node_within_parent.maximum_bounds.width).to eq(100)
      end
    end
  end
end
