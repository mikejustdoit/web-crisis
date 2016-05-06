require "box"

class Element
  def initialize(box: empty_box, children: [])
    @box = box
    @children = children.dup
  end

  attr_reader :box

  def children
    @children.dup
  end

  def content
    children.map(&:content).join
  end

  def draw(drawing_visitor)
    drawing_visitor.draw_box(self)
  end

  def layout(layout_visitor)
    layout_visitor.layout_node(self)
  end

  def with_box(new_box)
    Element.new(
      box: new_box,
      children: children,
    )
  end

  private

  def empty_box
    Box.new(0, 0, 0, 0)
  end
end
