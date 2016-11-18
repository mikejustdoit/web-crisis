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
      visit_text(node)
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

  def visit_text(positioned_node)
    positioned_node
  end

  def position_children(parent_node)
    ChildrenPositioner.new(
      first_child_positioner: first_child_positioner,
      subsequent_child_positioner: subsequent_child_positioner,
    )
    .call(parent_node)
  end

  def first_child_positioner
    ->(first_child, parent_node:) {
      FirstChildPositioner
        .new(parent_node: parent_node)
        .call(first_child)
    }
  end

  def subsequent_child_positioner
    ->(subsequent_child, preceding_sibling_node:) {
      SubsequentChildPositioner
        .new(preceding_sibling_node: preceding_sibling_node)
        .call(subsequent_child)
    }
  end
end
