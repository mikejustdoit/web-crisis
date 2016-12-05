class RootNodeDimensionsSetter
  def initialize(viewport_width:, viewport_height:)
    @viewport_width = viewport_width
    @viewport_height = viewport_height
  end

  def call(node)
    case node
    when Element
      visit_element(node)
    when Text
      node
    end
  end

  private

  def visit_element(node)
    node.clone_with(
      width: viewport_width,
      height: viewport_height,
    )
  end

  attr_reader :viewport_width, :viewport_height
end
