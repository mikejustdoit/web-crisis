require "box"
require "support/shared_examples/node"
require "support/visitor_double"
require "text"

RSpec.describe Text do
  subject(:node) { Text.new(box: box, content: text_content) }
  let(:text_content) { "Tweet of the week" }
  let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

  describe "#content" do
    it "returns the content it was initialised with" do
      expect(node.content).to eq(text_content)
    end
  end

  describe "working with node's position and dimensions" do
    it_behaves_like "a node with position and dimensions"
  end

  describe "cloning" do
    let(:node_specific_attribute) { :content }

    it_behaves_like "a clonable node"
  end

  describe "combining Text nodes" do
    subject(:hello_node) {
      Text.new(
        box: Box.new(x: 1, y: 1, width: 20, height: 6),
        content: "Hello",
      )
    }
    subject(:punctuation_node) {
      Text.new(
        box: Box.new(x: 0, y: 2, width: 2, height: 2),
        content: ", ",
      )
    }
    subject(:world_node) {
      Text.new(
        box: Box.new(x: 11, y: 4, width: 15, height: 25),
        content: "world!",
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
      subject(:node) { Text.new(content: "Tweet of the week") }

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
      subject(:node) { Text.new(box: box, content: "Tweet of the week") }
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
