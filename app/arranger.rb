require "children_measurer"
require "no_preceding_sibling"
require "node_types"
require "text_wrapper"

class Arranger
  def initialize(text_width_calculator:, viewport_width:, **)
    @text_width_calculator = text_width_calculator
    @viewport_width = viewport_width
  end

  def call(node)
    case node
    when *ELEMENTS
      visit_element(node)
    when Text
      visit_text(node)
    end
  end

  private

  attr_reader :text_width_calculator, :viewport_width

  def visit_element(positioned_node)
    arranged_children = arrange_children(positioned_node.children)

    inner_width, inner_height = measure_children_dimensions(arranged_children)

    positioned_node.clone_with(
      children: arranged_children,
      width: inner_width,
      height: inner_height,
    )
  end

  def visit_text(positioned_node)
    TextWrapper.new(positioned_node, text_width_calculator: text_width_calculator)
      .call(right_limit: viewport_width)
  end

  def arrange_children(children)
    return [] if children.empty?

    children.inject([]) { |arranged_children, child|
      preceding_sibling = arranged_children.last

      arranged_children + [
        *call(child.position_after(preceding_sibling || no_preceding_sibling))
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
