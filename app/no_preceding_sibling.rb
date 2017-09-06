require "point"

class NoPrecedingSibling
  def next_available_point
    Point.new(x: 0, y: 0)
  end

  def bottom
    0
  end
end
