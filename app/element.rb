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

  def accept_visit(visitor)
    visitor.visit_element(self)
  end

  def clone_with(**attributes)
    Element.new(
      box: attributes.fetch(:box, box),
      children: attributes.fetch(:children, children),
    )
  end

  private

  def empty_box
    Box.new(0, 0, 0, 0)
  end
end
