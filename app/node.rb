class Node
  def initialize(children: [])
    @children = children.dup
  end

  def map_children(mapper)
    children.map(&mapper)
  end

  private

  attr_reader :children
end
