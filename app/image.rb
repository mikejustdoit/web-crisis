require "box"
require "forwardable"

class Image
  extend Forwardable

  def initialize(box: Box.new, src:)
    @box = box
    @src = src
  end

  attr_reader :src

  def_delegators :box, :x, :y, :width, :height, :right, :bottom

  def content
    ""
  end

  def clone_with(**attributes)
    Image.new(
      box: box.clone_with(**attributes),
      src: attributes.fetch(:src, src),
    )
  end

  private

  attr_reader :box
end
