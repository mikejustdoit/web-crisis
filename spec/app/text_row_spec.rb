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
end
