class DrawingVisitor
  def initialize(text_renderer)
    @text_renderer = text_renderer
  end

  def draw_text(text)
    text_renderer.call(text)
  end

  private

  attr_reader :text_renderer
end
