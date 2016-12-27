require "intrinsic_width_setter"
require "support/gosu_adapter_stubs"
require "support/shared_examples/visitor"

RSpec.describe IntrinsicWidthSetter do
  subject(:visitor) {
    IntrinsicWidthSetter.new(
      text_width_calculator: text_width_calculator,
    )
  }
  let(:text_width_calculator) { gosu_text_width_calculator_stub }

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

    it "sets widths for the Texts in the tree" do
      expect(first_grandchild.width).not_to eq(returned_first_grandchild.width)
    end
  end
end
