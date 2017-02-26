require "block_level_element"
require "box"
require "children_consecutor"
require "inline_element"

RSpec.describe ChildrenConsecutor do
  subject(:consecutor) {
    ChildrenConsecutor.new([first_node, second_node, third_node, fourth_node])
  }
  let(:first_node) { BlockLevelElement.new(Element.new) }
  let(:second_node) { BlockLevelElement.new(Element.new) }
  let(:third_node) { InlineElement.new(Element.new) }
  let(:fourth_node) { InlineElement.new(Element.new) }

  describe "grouping" do
    let(:group_one) { consecutor.as_groups.first }
    let(:group_two) { consecutor.as_groups[1] }
    let(:group_three) { consecutor.as_groups.last }

    it "keeps block-level nodes in their own, individual groups" do
      expect(group_one).to eq([first_node])
      expect(group_two).to eq([second_node])
    end

    it "groups consecutive inline nodes" do
      expect(group_three).to eq([third_node, fourth_node])
    end
  end
end
