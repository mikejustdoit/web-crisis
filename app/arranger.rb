require "element_arranger"
require "node_types"
require "text_wrapper"

class Arranger
  def initialize(text_calculator:, **)
    @text_calculator = text_calculator
  end

  def call(node)
    if node.respond_to?(:children)
      visit_element(node)
    elsif node.respond_to?(:rows)
      visit_text(node)
    elsif node.respond_to?(:src)
      node
    else
      raise UnrecognisedNodeType.new
    end
  end

  private

  attr_reader :text_calculator

  def visit_element(positioned_node)
    ElementArranger.new(
      positioned_node,
      arrange_child: method(:call),
    ).call
  end

  def visit_text(positioned_node)
    wrapped_text = TextWrapper.new(
      positioned_node,
      text_calculator: text_calculator,
      maximum_bounds: positioned_node.maximum_bounds,
    ).call

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

  def minimum_children_position_offset(children)
    return children.map(&:x).min || 0, children.map(&:y).min || 0
  end
end
