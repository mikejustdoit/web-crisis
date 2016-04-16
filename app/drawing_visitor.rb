class DrawingVisitor
  def initialize(box_renderer:, text_renderer:)
    @box_renderer = box_renderer
    @text_renderer = text_renderer
  end

  def visit(tree)
    tree.draw(self)

    draw_children(tree)
  end

  def draw_box(box)
    box_renderer.call(box.x, box.y, box.width, box.height)
  end

  def draw_text(text, box)
    text_renderer.call(text, box.x, box.y)
  end

  private

  attr_reader :box_renderer, :text_renderer

  def draw_children(parent_node)
    parent_node.children.map(&method(:visit))
  end
end
