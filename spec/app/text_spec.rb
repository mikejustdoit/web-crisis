require "box"
require "point"
require "support/shared_examples/node"
require "support/visitor_double"
require "text"
require "text_row"

RSpec.describe Text do
  subject(:node) { Text.new(position: position, rows: rows, colour: :black) }
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

  describe "node's maximum bounds" do
    it "considers its maximum bounds permanently undefined" do
      expect(node.maximum_bounds).not_to be_defined
    end
  end

  describe "negotiating positions with consecutive nodes" do
    describe "determining our starting position" do
      subject(:node) {
        Text.new(
          position: Point.new(x: 100, y: 150),
          rows: double(:rows),
          colour: :black,
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
      subject(:node) { Text.new(position: position, rows: rows, colour: :black) }
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
