require "children_measurer"
require "no_preceding_sibling"
require "text_wrapper"

class Arranger
  def initialize(text_width_calculator:, viewport_width:, **)
    @text_width_calculator = text_width_calculator
    @viewport_width = viewport_width
  end

  def call(node)
    if node.respond_to?(:children)
      visit_element(node)
    else
      visit_text(node)
    end
  end

  private

  attr_reader :text_width_calculator, :viewport_width

  def visit_element(positioned_node)
    arranged_children = arrange_children(positioned_node.children)

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

  def visit_text(positioned_node)
    wrapped_text = TextWrapper.new(
      positioned_node,
      text_width_calculator: text_width_calculator,
    )
      .call(maximum_bounds: TextBounds.new(x: 0, width: viewport_width))

    x_offset, y_offset = minimum_children_position_offset(wrapped_text.rows)

    repositioned_rows = wrapped_text.rows.map { |row|
      row.clone_with(
        x: row.x - x_offset,
        y: row.y - y_offset,
      )
    }

    wrapped_text.clone_with(
      rows: repositioned_rows,
      x: wrapped_text.x + x_offset,
      y: wrapped_text.y + y_offset,
    )
  end

  def arrange_children(children)
    return [] if children.empty?

    children.inject([]) { |arranged_children, child|
      preceding_sibling = arranged_children.last

      arranged_children + [
        call(child.position_after(preceding_sibling || no_preceding_sibling))
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
