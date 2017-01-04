require "absolute_position_adder_upper"
require "height_calculator"
require "intrinsic_height_setter"
require "intrinsic_width_setter"
require "layout_pipeline"
require "position_calculator"
require "root_node_dimensions_setter"
require "width_calculator"

LAYOUT_VISITORS = LayoutPipeline.new(
  [
    RootNodeDimensionsSetter.method(:new),
    IntrinsicWidthSetter.method(:new),
    WidthCalculator.method(:new),
    IntrinsicHeightSetter.method(:new),
    HeightCalculator.method(:new),
    PositionCalculator.method(:new),
    AbsolutePositionAdderUpper.method(:new),
  ]
)
