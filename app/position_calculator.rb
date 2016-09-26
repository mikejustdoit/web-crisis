require "children_positioner"
require "first_child_position_calculator"
require "subsequent_child_position_calculator"

class PositionCalculator
  def initialize(**_); end

  def visit_element(positioned_node)
    new_children = position_children(positioned_node)

    positioned_node.clone_with(
      children: new_children.map { |positioned_child|
        positioned_child.accept_visit(self)
      }
    )
  end

  def visit_text(positioned_node)
    positioned_node
  end

  private

  def position_children(parent_node)
    ChildrenPositioner.new(
      first_child_position_calculator: first_child_position_calculator,
      subsequent_child_position_calculator: subsequent_child_position_calculator,
    )
    .call(parent_node)
  end

  def first_child_position_calculator
    ->(first_child, parent_node:) {
      FirstChildPositionCalculator
        .new(parent_node: parent_node)
        .call(first_child)
    }
  end

  def subsequent_child_position_calculator
    ->(subsequent_child, preceding_sibling_node:) {
      SubsequentChildPositionCalculator
        .new(preceding_sibling_node: preceding_sibling_node)
        .call(subsequent_child)
    }
  end
end
