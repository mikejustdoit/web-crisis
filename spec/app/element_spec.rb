require "box"
require "element"
require "support/shared_examples/node"
require "support/visitor_double"

RSpec.describe Element do
  describe "working with node's children" do
    subject(:node) { Element.new(children: children) }
    let(:children) { [first_child, second_child] }
    let(:first_child) { Element.new }
    let(:second_child) { Element.new }

    it_behaves_like "a render tree node"

    it "exposes its collection of children through a getter" do
      expect(node.children).to eq(children)
    end

    describe "cloning a node but with different children" do
      let(:new_children) { [Element.new] }

      before do
        @returned_node = node.clone_with(children: new_children)
      end

      it "doesn't change the old node's children" do
        expect(node.children).to eq(children)
        expect(node.children).not_to eq(new_children)
      end

      it "returns a new node" do
        expect(@returned_node).not_to eq(node)
      end

      it "assigns the new children to the new node" do
        expect(@returned_node.children).to eq(new_children)
      end
    end

    describe "immutability" do
      context "when collection supplied to #initialize is modified" do
        before do
          # initialize `node` _before_ modifying `children`
          node
          children.push(:oops)
        end

        it "doesn't affect the node" do
          expect(node.children).to eq([first_child, second_child])
        end
      end

      context "when collection returned from #children is modified" do
        before do
          node.children.push(:oops)
        end

        it "doesn't affect the node" do
          expect(node.children).to eq([first_child, second_child])
        end
      end
    end
  end

  describe "working with node's position and dimensions" do
    subject(:node) { Element.new(box: box, children: [Element.new]) }
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

    it_behaves_like "a node with position and dimensions"

    describe "node's maximum bounds" do
      it "considers its current x and width to be its maximum bounds" do
        expect(node.maximum_bounds.x).to eq(node.x)
        expect(node.maximum_bounds.width).to eq(node.width)
      end
    end
  end

  describe "cloning" do
    subject(:node) { Element.new(box: box, children: [Element.new]) }
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

    let(:node_specific_attribute) { :children }

    it_behaves_like "a clonable node"
  end

  describe "#content" do
    context "with children" do
      subject(:node) { Element.new(children: children) }

      let(:children) {
        [
          double(:first_child, :content => "first"),
          double(:second_child, :content => "second"),
        ]
      }

      it "concatenates content from all children" do
        expect(node.content).to eq("firstsecond")
      end
    end
  end
end
