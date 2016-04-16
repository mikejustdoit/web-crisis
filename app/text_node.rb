class TextNode
  def initialize(content:)
    @content = content
  end

  attr_reader :content

  def draw(drawing_visitor)
    drawing_visitor.draw_text(content)
  end

  def map_children(_mapper)
    []
  end

  def layout(layout_visitor)
    layout_visitor.layout_text_node(self)
  end
end
