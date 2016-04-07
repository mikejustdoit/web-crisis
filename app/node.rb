class Node
  def initialize(children: [])
    @children = children.dup
  end

  def map_children(mapper)
    children.map(&mapper)
  end

  def draw(drawing_visitor)
    draw_children(drawing_visitor)
  end

  private

  attr_reader :children

  def draw_children(drawing_visitor)
    children.each do |child|
      child.draw(drawing_visitor)
    end
  end
end
