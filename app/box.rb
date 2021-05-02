class Box
  def initialize(x: nil, y: nil, width: nil, height: nil)
    @x = x
    @y = y
    @width = width
    @height = height
  end

  def self.from(source_object)
    new(
      x: source_object.x,
      y: source_object.y,
      width: source_object.respond_to?(:width) ?  source_object.width : 1,
      height: source_object.respond_to?(:height) ?  source_object.height : 1,
    )
  end

  attr_reader :x, :y, :width, :height

  def right
    x + width
  end

  def bottom
    y + height
  end

  def overlaps?(other)
    return false unless self.defined? && Box.from(other).defined?

    other.bottom > y && other.y < bottom &&
      other.right > x && other.x < right
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
