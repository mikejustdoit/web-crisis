require "absolute_position_adder_upper"
require "arranger"
require "block_level_reverse_inheritor"
require "layout_pipeline"
require "root_node_dimensions_setter"

LAYOUT_VISITORS = LayoutPipeline.new(
  [
    BlockLevelReverseInheritor.method(:new),
    RootNodeDimensionsSetter.method(:new),
    Arranger.method(:new),
    AbsolutePositionAdderUpper.method(:new),
  ]
)
