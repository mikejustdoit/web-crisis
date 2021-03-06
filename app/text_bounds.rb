class TextBounds
  def initialize(x: nil, width: nil)
    @x = x
    @width = width
  end

  attr_reader :x, :width

  def right
    x + width
  end

  def clone_with(**attributes)
    TextBounds.new(
      x: attributes.fetch(:x, x),
      width: attributes.fetch(:width, width),
    )
  end

  def defined?
    ![x, width].any?(&:nil?)
  end

  def ==(other_text_bounds)
    x == other_text_bounds.x &&
      width == other_text_bounds.width
  end
end
