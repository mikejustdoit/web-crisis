class RootNodeDrawingVisitor
  def initialize(box_renderer:)
    @box_renderer = box_renderer
  end

  def call(node)
    box_renderer.call(node.x, node.y, node.width, node.height)

    node
  end

  private

  attr_reader :box_renderer
end
