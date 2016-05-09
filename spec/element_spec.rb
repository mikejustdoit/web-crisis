require "box"
require "element"
require "support/visitor_double"

RSpec.describe Element do
  describe "working with node's children" do
    subject(:node) { Element.new(children: children) }
    let(:children) { [first_child, second_child] }
    let(:first_child) { Element.new }
    let(:second_child) { Element.new }

    it "exposes its collection of children through a getter" do
      expect(node.children).to eq(children)
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

  describe "working with node's box" do
    subject(:node) { Element.new(box: box) }
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

  describe "accepting visitors" do
    subject(:node) { Element.new(box: box) }
    let(:box) { Box.new(0, 0, 10, 20) }

    let(:visitor) { visitor_double }

    before do
      node.accept_visit(visitor)
    end

    it "supplies itself to the visitor's callback" do
      expect(visitor).to have_received(:visit_element).with(node)
    end
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
