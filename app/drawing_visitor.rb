class DrawingVisitor
  def initialize(box_renderer:, text_renderer:)
    @box_renderer = box_renderer
    @text_renderer = text_renderer
  end

  def draw_box(box)
    box_renderer.call(box.x, box.y, box.width, box.height)
  end

  def draw_text(text)
    text_renderer.call(text)
  end

  private

  attr_reader :box_renderer, :text_renderer
end
