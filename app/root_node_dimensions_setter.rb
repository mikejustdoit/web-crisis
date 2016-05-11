require "box"

class RootNodeDimensionsSetter
  def initialize(viewport_width:, viewport_height:)
    @viewport_width = viewport_width
    @viewport_height = viewport_height
  end

  def visit(tree)
    tree.accept_visit(self)
  end

  def visit_element(node)
    node.clone_with(
      box: Box.new(
        node.box.x,
        node.box.y,
        viewport_width,
        viewport_height,
      )
    )
  end

  def visit_text(node); end

  private

  attr_reader :viewport_width, :viewport_height
end
