class FirstChildPositionCalculator
  def initialize(decorated_visitor:, parent_node:)
    @decorated_visitor = decorated_visitor
    @parent_node = parent_node
  end

  def visit_element(node)
    decorated_visitor.visit_element(
      positioned_node(node)
    )
  end

  def visit_text(node)
    decorated_visitor.visit_text(
      positioned_node(node)
    )
  end

  private

  attr_reader :decorated_visitor, :parent_node

  def positioned_node(node)
    node.clone_with(
      y: parent_node.y,
    )
  end
end
