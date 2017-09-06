require "block_level_element"
require "box"
require "element"

RSpec.describe BlockLevelElement do
  describe "cloning" do
    subject(:node) { BlockLevelElement.new(Element.new(children: [])) }
    let(:returned_node) { node.clone_with({}) }

    it "returns a BlockLevelElement" do
      expect(returned_node).to be_a(BlockLevelElement)
    end
  end

  describe "negotiating positions with consecutive nodes" do
    subject(:node) {
      BlockLevelElement.new(
        Element.new(
          box: Box.new(x: 100, y: 99, width: 98, height: 97),
          children: double(:children),
        )
      )
    }

    describe "determining our starting position" do
      let(:preceding_node) {
        double(:preceding_node, bottom: double(:preceding_node_bottom))
      }

      it "uses the preceding node's #bottom" do
        node.position_after(preceding_node)

        expect(preceding_node).to have_received(:bottom)
      end

      it "returns a new node" do
        expect(node.position_after(preceding_node)).not_to eq(node)
      end
    end

    describe "communicating the next available position for subsequent nodes" do
      it "uses its own outer x and bottom position" do
        expect(node.next_available_point.x).to eq(node.x)
        expect(node.next_available_point.y).to eq(node.bottom)
      end

      it "returns a point" do
        expect(node.next_available_point).to respond_to(:x)
        expect(node.next_available_point).to respond_to(:y)
      end
    end
  end
end
