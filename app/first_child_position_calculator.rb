class FirstChildPositionCalculator
  def initialize(decorated_visitor:, parent_node:)
    @decorated_visitor = decorated_visitor
    @parent_node = parent_node
  end

  def visit_element(node)
    decorated_visitor.visit_element(
      position_node(node)
    )
  end

  def visit_text(node)
    decorated_visitor.visit_text(
      position_node(node)
    )
  end

  private

  attr_reader :decorated_visitor, :parent_node

  def position_node(node)
    node.clone_with(
      y: parent_node.y,
    )
  end
end
