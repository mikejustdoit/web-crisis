require "children_arranger"
require "children_measurer"
require "node_types"

class PositionCalculator
  def initialize(**_); end

  def call(node)
    case node
    when *ELEMENTS
      visit_element(node)
    when Text
      node
    end
  end

  private

  def visit_element(node)
    children_with_positioned_children = node.children.map { |child| call(child) }

    positioned_children = position_children(children_with_positioned_children)

    inner_width, inner_height = measure_children_dimensions(positioned_children)

    node.clone_with(
      children: positioned_children,
      width: inner_width,
      height: inner_height,
    )
  end

  def position_children(children)
    ChildrenArranger.new(children).call
  end

  def measure_children_dimensions(children)
    ChildrenMeasurer.new.call(children)
  end
end
