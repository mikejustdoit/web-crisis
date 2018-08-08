class ImageDrawingVisitor
  def initialize(image_renderer:, **)
    @image_renderer = image_renderer
  end

  def call(node)
    if node.respond_to?(:src)
      image_renderer.call(node.filename, node.x, node.y)
    elsif node.respond_to?(:children)
      node.children.each { |child| call(child) }
    end

    node
  end

  private

  attr_reader :image_renderer
end
