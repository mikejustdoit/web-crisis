class ChildrenMeasurer
  def call(children)
    return total_width(children), total_height(children)
  end

  private

  def total_width(children)
    rightmost_position(children) - leftmost_position(children)
  end

  def leftmost_position(children)
    children.map(&:x).min || 0
  end

  def rightmost_position(children)
    children.map(&:right).max || 0
  end

  def total_height(children)
    bottommost_position(children) - topmost_position(children)
  end

  def topmost_position(children)
    children.map(&:y).min || 0
  end

  def bottommost_position(children)
    children.map(&:bottom).max || 0
  end
end
