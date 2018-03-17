require "node_within_parent"
require "text_bounds"

RSpec.describe NodeWithinParent do
  subject(:node_within_parent) { NodeWithinParent.new(node, parent) }

  describe "node's maximum bounds" do
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

  describe "cloning" do
    let(:node) {
      double(
        :node,
        :clone_with => double(:cloned_node),
        :position_after => double(:positioned_cloned_node),
      )
    }
    let(:parent) { double(:parent) }

    it "returns a NodeWithinParent" do
      expect(node_within_parent.clone_with({})).to be_a(NodeWithinParent)
    end

    describe "handling clones invoked from inside node's methods" do
      describe "overriding #position_after" do
        let(:preceding_node) { double(:preceding_node) }

        it "returns a NodeWithinParent" do
          expect(
            node_within_parent.position_after(preceding_node)
          ).to be_a(NodeWithinParent)
        end
      end
    end
  end
end
