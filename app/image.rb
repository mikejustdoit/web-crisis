require "box"
require "forwardable"

class Image
  extend Forwardable

  SUPPORTED_MIME_TYPES = %w{image/gif image/jpeg image/png}

  def initialize(box: Box.new, filename: placeholder_filename, src:)
    @box = box
    @filename = filename
    @src = src
  end

  attr_reader :filename, :src

  def_delegators :box, :x, :y, :width, :height, :right, :bottom, :overlaps?

  def content
    ""
  end

  def clone_with(**attributes)
    Image.new(
      box: box.clone_with(**attributes),
      filename: attributes.fetch(:filename, filename),
      src: attributes.fetch(:src, src),
    )
  end

  private

  attr_reader :box

  def placeholder_filename
    PLACEHOLDER_IMAGE
  end
end
