require "children_positioner"
require "node_types"

class PositionCalculator
  def initialize(**_); end

  def call(node)
    case node
    when *ELEMENTS
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
    ChildrenPositioner.new.call(parent_node)
  end
end
