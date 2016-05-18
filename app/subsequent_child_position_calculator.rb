class SubsequentChildPositionCalculator
  def initialize(decorated_visitor:, preceding_sibling_node:)
    @decorated_visitor = decorated_visitor
    @preceding_sibling_node = preceding_sibling_node
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

  attr_reader :decorated_visitor, :preceding_sibling_node

  def position_node(node)
    node.clone_with(
      y: preceding_sibling_node.bottom,
    )
  end
end
