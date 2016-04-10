require "box"
require "node"

RSpec.describe Node do
  describe "working with node's children" do
    subject(:node) { Node.new(children: children) }
    let(:children) { [first_child, second_child] }
    let(:first_child) { Node.new }
    let(:second_child) { Node.new }

    it "exposes its collection of children through a map method" do
      expect(node.map_children(->(child) { child })).to eq(children)
    end

    describe "immutability" do
      context "when collection supplied to #initialize is modified" do
        before do
          # initialize `node` _before_ modifying `children`
          node
          children.push(:oops)
        end

        it "doesn't affect the node" do
          expect(node.map_children(->(child) { child })).to eq(
            [first_child, second_child]
          )
        end
      end

      context "when collection returned from #map_children is modified" do
        before do
          node.map_children(->(child) { child }).push(:oops)
        end

        it "doesn't affect the node" do
          expect(node.map_children(->(child) { child })).to eq(children)
        end
      end
    end
  end

  describe "working with node's box" do
    subject(:node) { Node.new(box: box) }
    let(:box) { Box.new(*box_attributes) }
    let(:box_attributes) { [0, 1, 2, 3] }

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

  describe "drawing its box" do
    subject(:node) { Node.new(box: box) }
    let(:box) { Box.new(0, 0, 10, 20) }

    let(:drawing_visitor) { double(:drawing_visitor, :draw_box => nil) }

    before do
      node.draw(drawing_visitor)
    end

    it "supplies its position and dimensions to drawing visitor" do
      expect(drawing_visitor).to have_received(:draw_box).with(box)
    end
  end

  describe "laying itself out" do
    subject(:node) { Node.new(box: box) }
    let(:box) { Box.new(0, 0, 10, 20) }

    let(:layout_visitor) { double(:layout_visitor, :layout_node => nil) }

    before do
      node.layout(layout_visitor)
    end

    it "supplies itself to layout visitor" do
      expect(layout_visitor).to have_received(:layout_node).with(node)
    end
  end
end
