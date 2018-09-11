require "box"
require "build_text"
require "element"
require "link"
require "text_colourer"
require "support/shared_examples/visitor"

RSpec.describe TextColourer do
  subject(:visitor) { TextColourer.new }

  it_behaves_like "a visitor"

  it_behaves_like "a depth-first tree traverser"

  let(:root) { Element.new(children: [first_child, last_child_text]) }
  let(:first_child) {
    Link.new(
      Element.new(children: [first_grandchild_text, last_grandchild]),
      href: "/about-us",
    )
  }
  let(:first_grandchild_text) {
    BuildText.new.call(
      box: Box.new(x: 0, y: 0, width: 100, height: 100),
      content: "ABC",
    )
  }
  let(:last_grandchild) { Element.new }
  let(:last_child_text) { BuildText.new.call(content: "DEF") }

  let(:returned_root) { visitor.call(root) }
  let(:returned_first_child) { returned_root.children.first }
  let(:returned_first_grandchild_text) { returned_first_child.children.first }
  let(:returned_last_grandchild) { returned_first_child.children.last }
  let(:returned_last_child_text) { returned_root.children.last }

  it "sets Links' descendent Text nodes' colour to blue" do
    expect(returned_first_grandchild_text.colour).to eq(:blue)
  end

  it "sets all other Text nodes' colour to black" do
    expect(returned_last_child_text.colour).to eq(:black)
  end
end
