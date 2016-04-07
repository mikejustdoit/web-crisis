class TextNode
  def initialize(content:)
    @content = content
  end

  def draw(drawing_visitor)
    drawing_visitor.draw_text(content)
  end

  private

  attr_reader :content
end
