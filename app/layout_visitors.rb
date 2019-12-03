require "absolute_position_adder_upper"
require "arranger"
require "block_level_reverse_inheritor"
require "image_fetcher"
require "root_node_dimensions_setter"
require "text_colourer"
require "visitor_pipeline"

LAYOUT_VISITORS = VisitorPipeline.new(
  [
    ImageFetcher.method(:new),
    BlockLevelReverseInheritor.method(:new),
    RootNodeDimensionsSetter.method(:new),
    Arranger.method(:new),
    AbsolutePositionAdderUpper.method(:new),
    TextColourer.method(:new),
  ]
)
