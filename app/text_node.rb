require "box"

class TextNode
  def initialize(box: empty_box, content:)
    @box = box
    @content = content
  end

  attr_reader :box, :content

  def draw(drawing_visitor)
    drawing_visitor.draw_text(self)
  end

  def children
    []
  end

  def layout(layout_visitor)
    layout_visitor.layout_text_node(self)
  end

  def with_box(new_box)
    TextNode.new(
      box: new_box,
      content: content,
    )
  end

  private

  def empty_box
    Box.new(0, 0, 0, 0)
  end
end
