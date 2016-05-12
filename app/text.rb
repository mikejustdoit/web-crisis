require "box"
require "forwardable"

class Text
  extend Forwardable

  def initialize(box: empty_box, content:)
    @box = box
    @content = content
  end

  attr_reader :box, :content

  def_delegators :box, :x, :y, :width, :height

  def accept_visit(visitor)
    visitor.visit_text(self)
  end

  def children
    []
  end

  def clone_with(**attributes)
    Text.new(
      box: box.clone_with(**attributes),
      content: attributes.fetch(:content, content),
    )
  end

  private

  def empty_box
    Box.new(x: 0, y: 0, width: 0, height: 0)
  end
end
