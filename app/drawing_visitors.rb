require "drawing_visitor"
require "layout_pipeline"

DRAWING_VISITORS = LayoutPipeline.new(
  [
    DrawingVisitor.method(:new),
  ]
)
