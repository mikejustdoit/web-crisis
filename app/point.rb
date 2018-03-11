class Point
  def initialize(x:, y:)
    @x = x
    @y = y
  end

  attr_reader :x, :y

  def ==(other_point)
    x == other_point.x && y == other_point.y
  end

  def clone_with(**attributes)
    Point.new(
      x: attributes.fetch(:x, x),
      y: attributes.fetch(:y, y),
    )
  end
end
