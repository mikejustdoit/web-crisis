require "box"

class Node
  def initialize(box: empty_box, children: [])
    @box = box
    @children = children.dup
  end

  attr_reader :box

  def map_children(mapper)
    children.map(&mapper)
  end

  def draw(drawing_visitor)
    drawing_visitor.draw_box(box)
  end

  def layout(layout_visitor)
    layout_visitor.layout_node(self)
  end

  def with_box(new_box)
    Node.new(
      box: new_box,
      children: children,
    )
  end

  private

  attr_reader :children

  def empty_box
    Box.new(0, 0, 0, 0)
  end
end
