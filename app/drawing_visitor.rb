class DrawingVisitor
  def initialize(box_renderer:, text_renderer:)
    @box_renderer = box_renderer
    @text_renderer = text_renderer
  end

  def visit_element(node)
    box_renderer.call(node.x, node.y, node.width, node.height)

    node.children.each { |child| child.accept_visit(self) }

    node
  end

  def visit_text(node)
    text_renderer.call(node.content, node.x, node.y)

    node
  end

  private

  attr_reader :box_renderer, :text_renderer
end
