require "node_types"

class RootNodeDimensionsSetter
  def initialize(viewport_width:, viewport_height:, **)
    @viewport_width = viewport_width
    @viewport_height = viewport_height
  end

  def call(node)
    case node
    when *ELEMENTS
      visit_element(node)
    when Text
      node
    end
  end

  private

  def visit_element(node)
    node.clone_with(
      x: 0,
      y: 0,
      width: viewport_width,
      height: viewport_height,
    )
  end

  attr_reader :viewport_width, :viewport_height
end
