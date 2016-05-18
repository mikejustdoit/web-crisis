require "first_child_position_calculator"
require "subsequent_child_position_calculator"

class PositionCalculator
  def initialize(**_); end

  def visit_element(positioned_node)
    new_children = positioned_node.children.first(1)
      .map { |first_child|
        first_child.accept_visit(
          first_child_position_calculator(positioned_node)
        )
      }

    new_children = positioned_node.children.drop(1)
      .inject(new_children) { |preceding_children, child|
        preceding_children + [
          child.accept_visit(
            subsequent_child_position_calculator(preceding_children.last)
          )
        ]
      }

    positioned_node.clone_with(children: new_children)
  end

  def visit_text(positioned_node)
    positioned_node
  end

  def first_child_position_calculator(parent_node)
    FirstChildPositionCalculator.new(
      decorated_visitor: self,
      parent_node: parent_node,
    )
  end

  def subsequent_child_position_calculator(preceding_sibling_node)
    SubsequentChildPositionCalculator.new(
      decorated_visitor: self,
      preceding_sibling_node: preceding_sibling_node,
    )
  end
end
