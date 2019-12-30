class Point
  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def self.from(source_object)
    new(x: source_object.x, y: source_object.y)
  end

  attr_reader :x, :y

  def to_h
    {x: x, y: y}
  end

  def ==(other_point)
    x == other_point.x && y == other_point.y
  end

  def clone_with(**attributes)
    Point.new(
      x: attributes.fetch(:x, x),
      y: attributes.fetch(:y, y),
    )
  end

  def +(other_point)
    Point.new(
      x: x + other_point.x,
      y: y + other_point.y,
    )
  end
end
