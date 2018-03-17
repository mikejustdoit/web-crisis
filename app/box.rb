class Box
  def initialize(x: nil, y: nil, width: nil, height: nil)
    @x = x
    @y = y
    @width = width
    @height = height
  end

  attr_reader :x, :y, :width, :height

  def right
    x + width
  end

  def bottom
    y + height
  end

  def ==(other_box)
    [:x, :y, :width, :height]
      .all? { |attribute_name|
        self.send(attribute_name) == other_box.send(attribute_name)
      }
  end

  def clone_with(**attributes)
    Box.new(
      x: attributes.fetch(:x, x),
      y: attributes.fetch(:y, y),
      width: attributes.fetch(:width, width),
      height: attributes.fetch(:height, height),
    )
  end

  def defined?
    ![x, y, width, height].any?(&:nil?)
  end
end
