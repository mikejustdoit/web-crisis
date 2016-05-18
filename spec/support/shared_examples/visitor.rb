require "element"
require "support/visitor_double"
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

      root.accept_visit(visitor)
    end

    it "visits all nodes once in depth-first order" do
      expect(root).to have_received(:accept_visit).ordered
      expect(children.first).to have_received(:accept_visit).ordered
      expect(grandchildren.first).to have_received(:accept_visit).ordered
      expect(grandchildren.last).to have_received(:accept_visit).ordered
      expect(children.last).to have_received(:accept_visit).ordered
    end
  end
end

RSpec.shared_examples "a visitor decorator" do
  subject(:visitor_decorator) {
    visitor_decorator_class.new(
      decorated_visitor: its_decorated_visitor,
      **other_arguments,
    )
  }
  let(:its_decorated_visitor) { visitor_double }

  let(:element) { Element.new }
  let(:text) { Text.new(content: "srsly") }

  describe "ultimately delegating #visit_element" do
    before do
      visitor_decorator.visit_element(element)
    end

    it "delegates #visit_element" do
      expect(its_decorated_visitor).to have_received(:visit_element)
    end
  end

  describe "ultimately delegating #visit_text" do
    before do
      visitor_decorator.visit_text(text)
    end

    it "delegates #visit_text" do
      expect(its_decorated_visitor).to have_received(:visit_text)
    end
  end
end
