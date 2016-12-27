require "node_types"

class IntrinsicWidthSetter
  def initialize(text_width_calculator:, **)
    @text_width_calculator = text_width_calculator
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

  attr_reader :text_width_calculator

  def visit_element(node)
    new_children = node.children.map { |child|
      call(child)
    }

    node.clone_with(
      children: new_children,
    )
  end

  def visit_text(node)
    node.clone_with(
      width: text_width_calculator.call(node.content),
    )
  end
end
