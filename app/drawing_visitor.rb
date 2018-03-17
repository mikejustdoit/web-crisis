require "root_node_drawing_visitor"
require "text_drawing_visitor"

class DrawingVisitor
  def initialize(box_renderer:, text_renderer:)
    @box_renderer = box_renderer
    @text_renderer = text_renderer
  end

  def call(node)
    text_drawing_visitor.call(
      root_node_drawing_visitor.call(node)
    )
  end

  private

  def root_node_drawing_visitor
    RootNodeDrawingVisitor.new(box_renderer: box_renderer)
  end

  def text_drawing_visitor
    TextDrawingVisitor.new(text_renderer: text_renderer)
  end

  attr_reader :box_renderer, :text_renderer
end
