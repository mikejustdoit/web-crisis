require "element"
require "node_lister"

RSpec.describe NodeLister do
  subject(:node_lister) { NodeLister.new }

  it "turns the tree into a list" do
    grandchild_1 = Element.new
    grandchild_2 = Element.new
    grandchild_3 = Element.new
    child_1 = Element.new(children: [grandchild_1, grandchild_2])
    child_2 = Element.new(children: [grandchild_3])
    tree = Element.new(children: [child_1, child_2])

    expect(node_lister.call(tree)).to eq(
      [tree, child_1, grandchild_1, grandchild_2, child_2, grandchild_3]
    )
  end
end
