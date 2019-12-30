require "box"
require "point"
require "support/shared_examples/node"
require "support/visitor_double"
require "text"
require "text_row"

RSpec.describe Text do
  subject(:node) { Text.new(box: box, rows: rows, colour: :black) }
  let(:box) { Box.new(x: 0, y: 1, width: 2, height: 6) }
  let(:rows) { [first_row, second_row] }
  let(:first_row) {
    TextRow.new(
      box: Box.new(x: 0, y: 0, width: 2, height: 3),
      content: "Tweet of the",
    )
  }
  let(:second_row) {
    TextRow.new(
      box: Box.new(x: 0, y: 3, width: 1, height: 3),
      content: "Week",
    )
  }

  describe "#content" do
    it "presents its rows' content, with spaces" do
      expect(node.content).to eq("Tweet of the Week")
    end
  end

  it "has a colour" do
    expect(node.colour).to eq(:black)
  end

  describe "working with node's position and dimensions" do
    before do
      allow(first_row).to receive(:right).and_call_original
      allow(second_row).to receive(:right).and_call_original
      allow(first_row).to receive(:bottom).and_call_original
      allow(second_row).to receive(:bottom).and_call_original
    end

    it "exposes delegated getters for box's attributes" do
      expect(node.x).to eq(box.x)
      expect(node.y).to eq(box.y)
      expect(node.width).to eq(box.width)
      expect(node.height).to eq(box.height)
    end

    it "exposes position and dimension aggregate methods" do
      expect(node).to respond_to(:right)
      expect(node).to respond_to(:bottom)
    end

    describe "creating a new node with new attributes" do
      let(:new_attributes) { {:x => 10, :y => 10} }

      let(:clone_of_node) { node.clone_with(new_attributes) }

      it "doesn't change the old node's attributes" do
        expect(node.x).to eq(box.x)
        expect(node.y).to eq(box.y)
      end

      it "assigns the new node the specified attributes" do
        expect(clone_of_node.x).to eq(new_attributes.fetch(:x))
        expect(clone_of_node.y).to eq(new_attributes.fetch(:y))
      end
    end
  end

  describe "cloning" do
    let(:node_specific_attribute) { :rows }

    it_behaves_like "a clonable node"
  end

  describe "node's maximum bounds" do
    it "considers its maximum bounds permanently undefined" do
      expect(node.maximum_bounds).not_to be_defined
    end
  end

  describe "negotiating positions with consecutive nodes" do
    describe "determining our starting position" do
      subject(:node) {
        Text.new(
          box: Box.new(x: 100, y: 150, width: 10, height: 15),
          rows: double(:rows),
          colour: :black,
        )
      }

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
      subject(:node) { Text.new(box: nodes_box, rows: rows, colour: :black) }
      let(:nodes_box) { Box.new(x: 10, y: 15, width: 101, height: 152) }
      let(:rows) { [TextRow.new(box: final_rows_box, content: "Follow me.")] }
      let(:final_rows_box) { Box.new(x: 100, y: 150, width: 1, height: 2) }

      before do
        allow(nodes_box).to receive(:x).and_call_original
        allow(nodes_box).to receive(:y).and_call_original
        allow(final_rows_box).to receive(:right).and_call_original
        allow(final_rows_box).to receive(:y).and_call_original
      end

      it "uses the position after its final internal row's box" do
        node.next_available_point

        expect(nodes_box).to have_received(:x)
        expect(final_rows_box).to have_received(:right)
        expect(nodes_box).to have_received(:y)
        expect(final_rows_box).to have_received(:y)
      end

      it "returns a point" do
        expect(node.next_available_point).to respond_to(:x)
        expect(node.next_available_point).to respond_to(:y)
      end
    end
  end

  describe "bounding boxes for substring" do
    context "when the substring is contained within a single row" do
      it "returns the box of the entire row" do
        expect(node.bounding_boxes_for_substring(0..5)).to eq([Box.from(first_row)])
      end
    end

    context "when the substring is spread over multiple rows" do
      it "returns the boxes of all the rows involved" do
        expect(node.bounding_boxes_for_substring(9..15)).to eq(
          [Box.from(first_row), Box.from(second_row)]
        )
      end
    end

    context "when the given string location is out of range" do
      it "complains" do
        expect {
          node.bounding_boxes_for_substring(9..100)
        }.to raise_error(Text::OutOfContentRange)
      end
    end
  end
end
