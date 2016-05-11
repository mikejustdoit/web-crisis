class Box
  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end

  attr_reader :x, :y, :width, :height

  def ==(other_box)
    [:x, :y, :width, :height]
      .all? { |attribute_name|
        self.send(attribute_name) == other_box.send(attribute_name)
      }
  end

  def clone_with(**attributes)
    Box.new(
      attributes.fetch(:x, x),
      attributes.fetch(:y, y),
      attributes.fetch(:width, width),
      attributes.fetch(:height, height),
    )
  end
end
