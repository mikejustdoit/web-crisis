require "element"
require "node_counter"
require "text"

RSpec.describe NodeCounter do
  subject(:node_counter) { NodeCounter.new }

  context "when there's only a root node" do
    let(:tree) { Element.new(children: []) }

    it "includes the root node and the root node only" do
      expect(node_counter.call(tree)).to eq(1)
    end
  end

  context "when there're a few levels of nodes" do
    let(:tree) { Element.new(children: children) }
    let(:children) { [Text.new(content: "a"), Element.new(children: grandchildren)] }
    let(:grandchildren) { [Element.new, Element.new] }

    it "includes all nodes, including the root node" do
      expect(node_counter.call(tree)).to eq(1 + children.size + grandchildren.size)
    end
  end
end
