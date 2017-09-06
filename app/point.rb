class Point
  def initialize(x:, y:)
    @x = x
    @y = y
  end

  attr_reader :x, :y

  def ==(other_point)
    x == other_point.x && y == other_point.y
  end
end
