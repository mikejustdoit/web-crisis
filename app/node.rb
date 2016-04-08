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

    draw_children(drawing_visitor)
  end

  private

  attr_reader :children

  def draw_children(drawing_visitor)
    children.each do |child|
      child.draw(drawing_visitor)
    end
  end

  def empty_box
    Box.new(0, 0, 0, 0)
  end
end
