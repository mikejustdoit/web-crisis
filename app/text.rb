require "box"
require "forwardable"

class Text
  extend Forwardable

  def initialize(box: Box.new, content:)
    @box = box
    @content = content
  end

  attr_reader :content

  def_delegators :box, :x, :y, :width, :height, :right, :bottom

  def children
    []
  end

  def clone_with(**attributes)
    Text.new(
      box: box.clone_with(**attributes),
      content: attributes.fetch(:content, content),
    )
  end

  def +(other_text_node)
    clone_with(
      content: content + other_text_node.content,
      width: width + other_text_node.width,
      height: [height, other_text_node.height].max,
    )
  end

  private

  attr_reader :box
end
