require "intrinsic_height_setter"
require "support/shared_examples/visitor"

RSpec.describe IntrinsicHeightSetter do
  subject(:visitor) { IntrinsicHeightSetter.new }

  it_behaves_like "a visitor"

  it_behaves_like "a depth-first tree traverser"

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) { Element.new(children: [first_grandchild, last_grandchild]) }
    let(:first_grandchild) { Text.new(content: "ABC") }
    let(:last_grandchild) { Element.new }
    let(:last_child) { Element.new }

    let(:returned_root) { visitor.call(root) }
    let(:returned_first_child) { returned_root.children.first }
    let(:returned_first_grandchild) { returned_first_child.children.first }

    it "sets heights for the Texts in the tree" do
      expect(first_grandchild.height).not_to eq(returned_first_grandchild.height)
    end
  end
end
