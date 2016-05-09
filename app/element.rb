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

  def with_children(new_children)
    Element.new(
      box: box,
      children: new_children,
    )
  end

  def content
    children.map(&:content).join
  end

  def accept_visit(visitor)
    visitor.visit_element(self)
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
