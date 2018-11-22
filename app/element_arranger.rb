require "children_measurer"
require "no_preceding_sibling"
require "node_within_parent"

class ElementArranger
  def initialize(positioned_node, arrange_child:)
    @positioned_node = positioned_node
    @arrange_child = arrange_child
  end

  def call
    arranged_children = arrange_children(
      positioned_node.children.map { |child|
        NodeWithinParent.new(child, positioned_node)
      }
    )

    inner_width, inner_height = measure_children_dimensions(arranged_children)
    x_offset, y_offset = minimum_children_position_offset(arranged_children)

    repositioned_children = arranged_children.map { |child|
      child.clone_with(
        x: child.x - x_offset,
        y: child.y - y_offset,
      )
    }

    positioned_node.clone_with(
      children: repositioned_children,
      x: positioned_node.x + x_offset,
      y: positioned_node.y + y_offset,
      width: inner_width,
      height: inner_height,
    )
  end

  private

  attr_reader :positioned_node, :arrange_child

  def arrange_children(children)
    return [] if children.empty?

    children.inject([]) { |arranged_children, child|
      preceding_sibling = arranged_children.last

      arranged_children + [
        arrange_child.call(
          child.position_after(preceding_sibling || no_preceding_sibling)
        )
      ]
    }
  end

  def no_preceding_sibling
    NoPrecedingSibling.new
  end

  def measure_children_dimensions(children)
    ChildrenMeasurer.new.call(children)
  end

  def minimum_children_position_offset(children)
    return children.map(&:x).min || 0, children.map(&:y).min || 0
  end
end
