require "inline_element"
require "element"
require "point"

RSpec.describe InlineElement do
  describe "cloning" do
    subject(:node) { InlineElement.new(Element.new(children: [])) }
    let(:returned_node) { node.clone_with({}) }

    it "returns a InlineElement" do
      expect(returned_node).to be_a(InlineElement)
    end
  end

  describe "negotiating positions with consecutive nodes" do
    subject(:node) { InlineElement.new(Element.new) }

    describe "determining our starting position" do
      let(:preceding_node) {
        double(:preceding_node, next_available_point: Point.new(x: 1, y: 2))
      }

      it "returns the preceding node's #next_available_point" do
        expect(
          node.the_position_after(preceding_node)
        ).to eq(preceding_node.next_available_point)
      end
    end

    describe "communicating the next available position for subsequent nodes" do
      context "when element has children" do
        subject(:node) {
          InlineElement.new(Element.new(
            box: Box.new(x: 100, y: 300, width: 10, height: 3),
            children: [first_child, last_child],
          ))
        }
        let(:first_child) { double(:first_child) }
        let(:last_child) {
          InlineElement.new(Element.new(
            box: Box.new(x: 50, y: 70, width: 5, height: 7),
          ))
        }

        before do
          allow(last_child).to receive(:next_available_point).and_call_original
        end

        it "uses its final child's next_available_point" do
          node.next_available_point

          expect(last_child).to have_received(:next_available_point)
        end

        it "returns a point" do
          expect(node.next_available_point).to respond_to(:x)
          expect(node.next_available_point).to respond_to(:y)
        end

        it "offsets its child's next_available_point to make it relevant" do
          expect(node.next_available_point.x).to eq(
            last_child.next_available_point.x + node.x
          )
          expect(node.next_available_point.y).to eq(
            last_child.next_available_point.y + node.y
          )
        end
      end

      context "when element doesn't have any children" do
        subject(:node) { InlineElement.new(Element.new(box: box)) }
        let(:box) {
          double(
            :box,
            right: double(:box_right),
            y: double(:box_y),
          )
        }

        it "uses the position after its box" do
          node.next_available_point

          expect(box).to have_received(:right)
          expect(box).to have_received(:y)
        end

        it "returns a point" do
          expect(node.next_available_point).to respond_to(:x)
          expect(node.next_available_point).to respond_to(:y)
        end
      end
    end
  end
end
