class DrawingVisitor
  def initialize(box_renderer:, text_renderer:)
    @box_renderer = box_renderer
    @text_renderer = text_renderer
  end

  def visit(tree)
    tree.draw(self)
  end

  def draw_box(node)
    box_renderer.call(node.box.x, node.box.y, node.box.width, node.box.height)

    draw_children(node)
  end

  def draw_text(node)
    text_renderer.call(node.content, node.box.x, node.box.y)
  end

  private

  attr_reader :box_renderer, :text_renderer

  def draw_children(parent_node)
    parent_node.children.map(&method(:visit))
  end
end
