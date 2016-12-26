require "node_types"

class DrawingVisitor
  def initialize(box_renderer:, text_renderer:)
    @box_renderer = box_renderer
    @text_renderer = text_renderer
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

  def visit_element(node)
    box_renderer.call(node.x, node.y, node.width, node.height)

    node.children.each { |child| call(child) }

    node
  end

  def visit_text(node)
    text_renderer.call(node.content, node.x, node.y)

    node
  end

  attr_reader :box_renderer, :text_renderer
end
