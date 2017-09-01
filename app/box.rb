class Box
  UNDEFINED = Module.new

  def initialize(x: UNDEFINED, y: UNDEFINED, width: UNDEFINED, height: UNDEFINED)
    @x = x ? x : UNDEFINED
    @y = y ? y : UNDEFINED
    @width = width ? width : UNDEFINED
    @height = height ? height : UNDEFINED
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
    [x, y, width, height].all? { |attribute| attribute != UNDEFINED }
  end
end
