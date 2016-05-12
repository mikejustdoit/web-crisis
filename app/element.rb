require "box"
require "forwardable"

class Element
  extend Forwardable

  def initialize(box: empty_box, children: [])
    @box = box
    @children = children.dup
  end

  attr_reader :box

  def_delegators :box, :x, :y, :width, :height

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
      box: box.clone_with(**attributes),
      children: attributes.fetch(:children, children),
    )
  end

  private

  def empty_box
    Box.new(x: 0, y: 0, width: 0, height: 0)
  end
end
