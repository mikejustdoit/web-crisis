class Image
  def initialize(src:)
    @src = src
  end

  attr_reader :src

  def clone_with(**attributes)
    Image.new(
      src: attributes.fetch(:src, src),
    )
  end
end
