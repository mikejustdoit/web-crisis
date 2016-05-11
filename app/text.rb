require "box"

class Text
  def initialize(box: empty_box, content:)
    @box = box
    @content = content
  end

  attr_reader :box, :content

  def accept_visit(visitor)
    visitor.visit_text(self)
  end

  def children
    []
  end

  def clone_with(**attributes)
    Text.new(
      box: attributes.fetch(:box, box),
      content: attributes.fetch(:content, content),
    )
  end

  private

  def empty_box
    Box.new(0, 0, 0, 0)
  end
end
