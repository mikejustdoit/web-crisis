require "inspector"
require "node"
require "text_node"

RSpec.describe Inspector do
  subject(:inspector) { Inspector.new(tree) }

  describe "#find_nodes_with_text" do
    context "when tree has a single node" do
      let(:tree) { root_node }

      context "and the tree contains the search text" do
        let(:root_node) { TextNode.new(content: "search string") }

        it "returns the root node" do
          expect(inspector.find_nodes_with_text("search")).to eq([root_node])
        end
      end

      context "and the text is not in the tree" do
        let(:root_node) { TextNode.new(content: "other things") }

        it "returns an empty array" do
          expect(inspector.find_nodes_with_text("search")).to eq([])
        end
      end
    end

    context "when the tree has some nodes" do
      let(:root_node) { Node.new(children: children) }
      let(:children) {
        [
          Node.new(children: grandchildren),
          Node.new(children: other_grandchildren),
        ]
      }
      let(:grandchildren) {
        [
          TextNode.new(content: "not very "),
          Node.new,
          TextNode.new(content: "interesting stuff"),
        ]
      }
      let(:other_grandchildren) { [TextNode.new(content: "things of interest")] }

      let(:tree) { root_node }

      context "and a leaf node contains the search text" do
        it "returns the deepest node with the text" do
          expect(
            inspector.find_nodes_with_text("interesting")
          ).to eq([grandchildren.last])
        end
      end

      context "and a branch node contains the search text" do
        it "returns the deepest node with the whole text" do
          expect(
            inspector.find_nodes_with_text("very interesting")
          ).to eq([children.first])
        end
      end

      context "and more than one node contains the search text" do
        it "returns the all the deepest nodes with the text" do
          expect(
            inspector.find_nodes_with_text("interest")
          ).to eq([grandchildren.last, other_grandchildren.first])
        end
      end
    end
  end
end
