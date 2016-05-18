class SubsequentChildPositionCalculator
  def initialize(decorated_visitor:, preceding_sibling_node:)
    @decorated_visitor = decorated_visitor
    @preceding_sibling_node = preceding_sibling_node
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

  attr_reader :decorated_visitor, :preceding_sibling_node

  def positioned_node(node)
    node.clone_with(
      y: preceding_sibling_node.y + preceding_sibling_node.height,
    )
  end
end
