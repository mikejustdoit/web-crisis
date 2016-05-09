require "element"
require "text"

RSpec.shared_examples "a visitor" do
  describe "callback interface" do
    it "supports Element nodes" do
      expect(visitor).to respond_to(:visit_element)
    end

    it "supports Text nodes" do
      expect(visitor).to respond_to(:visit_text)
    end
  end
end

RSpec.shared_examples "a depth-first tree traverser" do
  describe "traversal" do
    let(:root) { Element.new(children: children) }
    let(:children) { [Element.new(children: grandchildren), Element.new] }
    let(:grandchildren) { [Text.new(content: "ABC"), Element.new] }

    let(:all_nodes) { [root] + children + grandchildren }

    before do
      all_nodes.each do |node|
        allow(node).to receive(:accept_visit).and_call_original
      end

      visitor.visit(root)
    end

    it "visits all nodes once in depth-first order" do
      expect(root).to have_received(:accept_visit).with(visitor).ordered
      expect(children.first).to have_received(:accept_visit).with(visitor).ordered
      expect(grandchildren.first).to have_received(:accept_visit).with(visitor).ordered
      expect(grandchildren.last).to have_received(:accept_visit).with(visitor).ordered
      expect(children.last).to have_received(:accept_visit).with(visitor).ordered
    end
  end
end
