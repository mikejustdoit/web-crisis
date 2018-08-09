require "image_drawing_visitor"
require "layout_pipeline"
require "root_node_drawing_visitor"
require "text_drawing_visitor"

DRAWING_VISITORS = LayoutPipeline.new(
  [
    RootNodeDrawingVisitor.method(:new),
    TextDrawingVisitor.method(:new),
    ImageDrawingVisitor.method(:new),
  ]
)
