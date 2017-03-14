require "element"
require "inspector"
require "text"

RSpec.describe Inspector do
  subject(:inspector) { Inspector.new(root_node) }

  describe "#find_nodes_with_text" do
    context "when tree has a single node" do
      context "and the tree contains the search text" do
        let(:root_node) { Text.new(content: "search string") }

        it "returns the root node" do
          expect(inspector.find_nodes_with_text("search")).to eq([root_node])
        end
      end

      context "and the text is not in the tree" do
        let(:root_node) { Text.new(content: "other things") }

        it "returns an empty array" do
          expect(inspector.find_nodes_with_text("search")).to eq([])
        end
      end
    end

    context "when the tree has some nodes" do
      let(:root_node) { Element.new(children: children) }
      let(:children) {
        [
          Element.new(children: grandchildren),
          Element.new(children: other_grandchildren),
        ]
      }
      let(:grandchildren) {
        [
          Text.new(content: "not very "),
          Element.new,
          Text.new(content: "interesting stuff"),
        ]
      }
      let(:other_grandchildren) { [Text.new(content: "things of interest")] }

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

  describe "#find_single_node_with_text" do
    let(:root_node) { Element.new(children: children) }
    let(:children) {
      [
        Text.new(content: "Anyone who has struggled with a genuine problem"),
        Text.new(content: " without having been taught an explicit method"),
      ]
    }

    context "a leaf node contains the search text" do
      it "returns the deepest node with the text" do
        expect(
          inspector.find_single_node_with_text("Anyone who has struggled")
        ).to eq(children.first)
      end
    end

    context "a branch node contains the search text" do
      it "returns the deepest node with the whole text" do
        expect(
          inspector.find_single_node_with_text("genuine problem without having")
        ).to eq(root_node)
      end
    end

    context "more than one node contains the search text" do
      it "complains loudly" do
        expect{
          inspector.find_single_node_with_text("with")
        }.to raise_error(Inspector::TooManyMatchesFound)
      end
    end

    context "the text is not in the tree" do
      it "complains loudly about this too" do
        expect{
          inspector.find_single_node_with_text("search string that isn't in tree")
        }.to raise_error(Inspector::NotEnoughMatchesFound)
      end
    end
  end
end
