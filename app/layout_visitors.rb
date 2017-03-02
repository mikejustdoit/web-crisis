require "absolute_position_adder_upper"
require "arranger"
require "block_level_reverse_inheritor"
require "intrinsic_height_setter"
require "intrinsic_width_setter"
require "layout_pipeline"
require "root_node_dimensions_setter"

LAYOUT_VISITORS = LayoutPipeline.new(
  [
    BlockLevelReverseInheritor.method(:new),
    RootNodeDimensionsSetter.method(:new),
    IntrinsicWidthSetter.method(:new),
    IntrinsicHeightSetter.method(:new),
    Arranger.method(:new),
    AbsolutePositionAdderUpper.method(:new),
  ]
)
