require "node"
require "node_counter"

RSpec.describe NodeCounter do
  subject(:node_counter) { NodeCounter.new }

  context "when there's only a root node" do
    let(:tree) { Node.new(children: []) }

    it "includes the root node and the root node only" do
      expect(node_counter.call(tree)).to eq(1)
    end
  end

  context "when there're a few levels of nodes" do
    let(:tree) { Node.new(children: children) }
    let(:children) { [Node.new, Node.new(children: grandchildren)] }
    let(:grandchildren) { [Node.new, Node.new] }

    it "includes all nodes, including the root node" do
      expect(node_counter.call(tree)).to eq(1 + children.size + grandchildren.size)
    end
  end
end
