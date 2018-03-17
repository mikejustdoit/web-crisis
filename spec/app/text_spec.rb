require "box"
require "point"
require "support/shared_examples/node"
require "support/visitor_double"
require "text"
require "text_row"

RSpec.describe Text do
  subject(:node) { Text.new(position: position, rows: rows) }
  let(:position) { Point.new(x: 0, y: 1) }
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

  describe "working with node's position and dimensions" do
    before do
      allow(first_row).to receive(:right).and_call_original
      allow(second_row).to receive(:right).and_call_original
      allow(first_row).to receive(:bottom).and_call_original
      allow(second_row).to receive(:bottom).and_call_original
    end

    it "exposes delegated getters for position's attributes" do
      expect(node.x).to eq(position.x)
      expect(node.y).to eq(position.y)
    end

    it "derives its width from its internal rows" do
      node.width

      expect(first_row).to have_received(:right)
      expect(second_row).to have_received(:right)
    end

    it "derives its height from its internal rows" do
      node.height

      expect(first_row).to have_received(:bottom)
      expect(second_row).to have_received(:bottom)
    end

    it "exposes position and dimension aggregate methods" do
      expect(node).to respond_to(:right)
      expect(node).to respond_to(:bottom)
    end

    describe "creating a new node with new attributes" do
      let(:new_attributes) { {:x => 10, :y => 10} }

      let(:clone_of_node) { node.clone_with(new_attributes) }

      it "doesn't change the old node's attributes" do
        expect(node.x).to eq(position.x)
        expect(node.y).to eq(position.y)
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

  describe "combining Text nodes" do
    subject(:hello_node) {
      Text.new(
        position: Point.new(x: 1, y: 1),
        rows: [
          TextRow.new(
            box: Box.new(x: 0, y: 0, width: 20, height: 6),
            content: "Hello",
          ),
        ],
      )
    }
    subject(:punctuation_node) {
      Text.new(
        position: Point.new(x: 0, y: 2),
        rows: [
          TextRow.new(
            box: Box.new(x: 0, y: 0, width: 2, height: 2),
            content: ", ",
          ),
        ],
      )
    }
    subject(:world_node) {
      Text.new(
        position: Point.new(x: 11, y: 4),
        rows: [
          TextRow.new(
            box: Box.new(x: 0, y: 0, width: 15, height: 25),
            content: "world!",
          ),
        ],
      )
    }

    let(:combined_node) { hello_node + punctuation_node + world_node }

    it "returns a new Text node" do
      [hello_node, punctuation_node, world_node].each do |original_node|
        expect(combined_node).not_to eq(original_node)
      end
    end

    it "combines the text content" do
      expect(combined_node.content).to eq("Hello, world!")
    end

    it "takes the first node's position" do
      expect(combined_node.x).to eq(hello_node.x)
      expect(combined_node.y).to eq(hello_node.y)
    end

    it "takes the combined width" do
      expect(combined_node.width).to eq(
        hello_node.width + punctuation_node.width + world_node.width
      )
    end

    it "takes the largest height" do
      expect(combined_node.height).to eq(
        [hello_node.height, punctuation_node.height, world_node.height].max
      )
    end
  end

  describe "negotiating positions with consecutive nodes" do
    describe "determining our starting position" do
      subject(:node) {
        Text.new(
          position: Point.new(x: 100, y: 150),
          rows: double(:rows),
        )
      }

      let(:preceding_node) {
        double(:preceding_node, next_available_point: Point.new(x: 1, y: 2))
      }

      it "uses the preceding node's #next_available_point" do
        node.position_after(preceding_node)

        expect(preceding_node).to have_received(:next_available_point)
      end

      it "returns a new node" do
        expect(node.position_after(preceding_node)).not_to eq(node)
      end
    end

    describe "communicating the next available position for subsequent nodes" do
      subject(:node) { Text.new(position: position, rows: rows) }
      let(:position) { Point.new(x: 10, y: 15) }
      let(:rows) { [TextRow.new(box: final_rows_box, content: "Follow me.")] }
      let(:final_rows_box) { Box.new(x: 100, y: 150, width: 1, height: 2) }

      before do
        allow(position).to receive(:x).and_call_original
        allow(position).to receive(:y).and_call_original
        allow(final_rows_box).to receive(:right).and_call_original
        allow(final_rows_box).to receive(:y).and_call_original
      end

      it "uses the position after its final internal row's box" do
        node.next_available_point

        expect(position).to have_received(:x)
        expect(final_rows_box).to have_received(:right)
        expect(position).to have_received(:y)
        expect(final_rows_box).to have_received(:y)
      end

      it "returns a point" do
        expect(node.next_available_point).to respond_to(:x)
        expect(node.next_available_point).to respond_to(:y)
      end
    end
  end
end
