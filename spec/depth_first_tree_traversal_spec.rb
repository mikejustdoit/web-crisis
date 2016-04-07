require "node"
require "text_node"

RSpec.describe "depth-first tree traversal" do
  let(:root) { Node.new(children: children) }
  let(:children) { [Node.new(children: grandchildren), Node.new] }
  let(:grandchildren) { [TextNode.new(content: "ABC"), Node.new] }

  let(:all_nodes) { [root] + children + grandchildren }

  let(:drawing_visitor) { double(:drawing_visitor, :draw_text => nil) }

  before do
    all_nodes.each do |node|
      allow(node).to receive(:draw).and_call_original
    end

    root.draw(drawing_visitor)
  end

  it "sends #draw to all nodes once in depth-first order" do
    expect(root).to have_received(:draw).ordered
    expect(children.first).to have_received(:draw).ordered
    expect(grandchildren.first).to have_received(:draw).ordered
    expect(grandchildren.last).to have_received(:draw).ordered
    expect(children.last).to have_received(:draw).ordered
  end
end
