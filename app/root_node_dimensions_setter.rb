require "box"

class RootNodeDimensionsSetter
  def initialize(viewport_width, viewport_height)
    @viewport_width = viewport_width
    @viewport_height = viewport_height
  end

  def visit(tree)
    tree.layout(self)
  end

  def layout_element(node)
    node.with_box(
      Box.new(
        node.box.x,
        node.box.y,
        viewport_width,
        viewport_height,
      )
    )
  end

  def layout_text(node); end

  private

  attr_reader :viewport_width, :viewport_height
end
