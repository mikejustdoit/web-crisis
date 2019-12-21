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
    TextWrapper.new(
      positioned_node,
      text_calculator: text_calculator,
      maximum_bounds: positioned_node.maximum_bounds,
    ).call
  end
end
