require "image_drawing_visitor"
require "root_node_drawing_visitor"
require "text_drawing_visitor"
require "visitor_pipeline"

DRAWING_VISITORS = VisitorPipeline.new(
  [
    RootNodeDrawingVisitor.method(:new),
    TextDrawingVisitor.method(:new),
    ImageDrawingVisitor.method(:new),
  ]
)
