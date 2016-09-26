class ChildrenPositioner
  def initialize(first_child_position_calculator:, subsequent_child_position_calculator:)
    @first_child_position_calculator = first_child_position_calculator
    @subsequent_child_position_calculator = subsequent_child_position_calculator
  end

  def call(node)
    new_children = node.children.first(1)
      .map { |first_child|
        position_first_child(
          first_child,
          parent_node: node,
        )
      }

    new_children = node.children.drop(1)
      .inject(new_children) { |preceding_children, child|
        preceding_children + [
          position_subsequent_child(
            child,
            preceding_sibling_node: preceding_children.last,
          )
        ]
      }

    new_children
  end

  private

  attr_reader :first_child_position_calculator,
    :subsequent_child_position_calculator

  def position_first_child(first_child, parent_node:)
    first_child_position_calculator.call(
      first_child,
      parent_node: parent_node,
    )
  end

  def position_subsequent_child(subsequent_child, preceding_sibling_node:)
    subsequent_child_position_calculator.call(
      subsequent_child,
      preceding_sibling_node: preceding_sibling_node,
    )
  end
end
