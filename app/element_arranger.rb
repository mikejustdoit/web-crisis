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

    positioned_node.clone_with(
      children: arranged_children,
      width: inner_width,
      height: inner_height,
    )
  end

  private

  attr_reader :positioned_node, :arrange_child

  def arrange_children(children)
    return [] if children.empty?

    children.inject([]) { |arranged_children, child|
      preceding_sibling = arranged_children.last || no_preceding_sibling

      arranged_children + [
        arrange_child.call(
          child.clone_with(**(child.the_position_after(preceding_sibling).to_h))
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
end
