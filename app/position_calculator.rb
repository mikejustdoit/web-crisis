require "first_child_position_calculator"
require "subsequent_child_position_calculator"

class PositionCalculator
  def initialize(**_); end

  def visit_element(positioned_node)
    new_children = positioned_node.children.first(1)
      .map { |first_child|
        position_first_child(
          first_child,
          parent_node: positioned_node,
        )
      }

    new_children = positioned_node.children.drop(1)
      .inject(new_children) { |preceding_children, child|
        preceding_children + [
          position_subsequent_child(
            child,
            preceding_sibling_node: preceding_children.last,
          )
        ]
      }

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

  def position_first_child(first_child, parent_node:)
    FirstChildPositionCalculator
      .new(parent_node: parent_node)
      .call(first_child)
  end

  def position_subsequent_child(subsequent_child, preceding_sibling_node:)
    SubsequentChildPositionCalculator
      .new(preceding_sibling_node: preceding_sibling_node)
      .call(subsequent_child)
  end
end
