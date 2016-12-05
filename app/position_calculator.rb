require "children_positioner"
require "first_child_positioner"
require "subsequent_child_positioner"

class PositionCalculator
  def initialize(**_); end

  def call(node)
    case node
    when Element
      visit_element(node)
    when Text
      node
    end
  end

  private

  def visit_element(positioned_node)
    new_children = position_children(positioned_node)

    positioned_node.clone_with(
      children: new_children.map { |positioned_child|
        call(positioned_child)
      }
    )
  end

  def position_children(parent_node)
    ChildrenPositioner.new(
      first_child_positioner: FirstChildPositioner.new,
      subsequent_child_positioner: SubsequentChildPositioner.new,
    )
    .call(parent_node)
  end
end
