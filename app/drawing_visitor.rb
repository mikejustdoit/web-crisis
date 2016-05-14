class DrawingVisitor
  def initialize(box_renderer:, text_renderer:)
    @box_renderer = box_renderer
    @text_renderer = text_renderer
  end

  def visit_element(node)
    box_renderer.call(node.x, node.y, node.width, node.height)

    visit_children(node)
  end

  def visit_text(node)
    text_renderer.call(node.content, node.x, node.y)
  end

  private

  attr_reader :box_renderer, :text_renderer

  def visit_children(parent_node)
    parent_node.children.map { |child| child.accept_visit(self) }
  end
end
