require "image_drawing_visitor"
require "root_node_drawing_visitor"
require "scroll_positioner"
require "text_drawing_visitor"
require "visitor_pipeline"

DRAWING_VISITORS = VisitorPipeline.new(
  [
    ScrollPositioner.method(:new),
    RootNodeDrawingVisitor.method(:new),
    TextDrawingVisitor.method(:new),
    ImageDrawingVisitor.method(:new),
  ]
)
