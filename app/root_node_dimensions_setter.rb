require "box"

class RootNodeDimensionsSetter
  def initialize(window_width, window_height)
    @window_width = window_width
    @window_height = window_height
  end

  def visit(tree)
    tree.layout(self)
  end

  def layout_node(node)
    node.with_box(
      Box.new(
        node.box.x,
        node.box.y,
        window_width,
        window_height,
      )
    )
  end

  private

  attr_reader :window_width, :window_height
end
