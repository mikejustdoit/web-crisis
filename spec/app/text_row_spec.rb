require "box"
require "support/shared_examples/node"
require "text_row"

RSpec.describe TextRow do
  subject(:node) { TextRow.new(box: box, content: text_content) }
  let(:text_content) { "Tweet of the week" }
  let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

  describe "#content" do
    it "returns the content it was initialised with" do
      expect(node.content).to eq(text_content)
    end
  end

  describe "working with row's position and dimensions" do
    it_behaves_like "a node with position and dimensions"
  end

  describe "cloning" do
    let(:node_specific_attribute) { :content }

    it_behaves_like "a clonable node"
  end

  describe "combining TextRows" do
    subject(:hello_row) {
      TextRow.new(
        box: Box.new(x: 1, y: 1, width: 20, height: 6),
        content: "Hello",
      )
    }
    subject(:punctuation_row) {
      TextRow.new(
        box: Box.new(x: 0, y: 2, width: 2, height: 2),
        content: ", ",
      )
    }
    subject(:world_row) {
      TextRow.new(
        box: Box.new(x: 11, y: 4, width: 15, height: 25),
        content: "world!",
      )
    }

    let(:combined_row) { hello_row + punctuation_row + world_row }

    it "returns a new TextRow" do
      [hello_row, punctuation_row, world_row].each do |original_row|
        expect(combined_row).not_to eq(original_row)
      end
    end

    it "combines the text content" do
      expect(combined_row.content).to eq("Hello, world!")
    end

    it "takes the first row's position" do
      expect(combined_row.x).to eq(hello_row.x)
      expect(combined_row.y).to eq(hello_row.y)
    end

    it "takes the combined width" do
      expect(combined_row.width).to eq(
        hello_row.width + punctuation_row.width + world_row.width
      )
    end

    it "takes the largest height" do
      expect(combined_row.height).to eq(
        [hello_row.height, punctuation_row.height, world_row.height].max
      )
    end
  end

  describe "communicating the next available position for subsequent rows" do
    subject(:row) { TextRow.new(box: box, content: "Follow me.") }
    let(:box) { Box.new(x: 100, y: 150, width: 1, height: 2) }

    before do
      allow(box).to receive(:right).and_call_original
      allow(box).to receive(:y).and_call_original
    end

    it "uses the position after its box's right" do
      row.next_available_point

      expect(box).to have_received(:right)
    end

    it "uses the position at the same level as its box" do
      row.next_available_point

      expect(box).to have_received(:y)
    end

    it "returns a point" do
      expect(node.next_available_point).to respond_to(:x)
      expect(node.next_available_point).to respond_to(:y)
    end
  end

  describe "comparing to another row" do
    subject(:row) { TextRow.new(box: box, content: "I am what I do.") }
    let(:box) { Box.new(x: 100, y: 150, width: 1, height: 2) }

    context "with different content, postion or dimensions" do
      let(:other_row) { TextRow.new(box: box, content: "I am something else.") }

      it "does not equal that other row" do
        expect( row == other_row ).not_to be true
      end
    end

    context "with identical content, postion and dimensions" do
      let(:other_row) { TextRow.new(box: box, content: "I am what I do.") }

      it "does equal that other row" do
        expect( row == other_row ).to be true
      end
    end
  end
end
