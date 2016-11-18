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

  describe "quacking like an Element" do
    it "has a #children method" do
      expect(node).to respond_to(:children)
    end

    it "returns an empty array" do
      expect(node.children).to eq([])
    end
  end
end
