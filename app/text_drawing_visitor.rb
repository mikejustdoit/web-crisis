class TextDrawingVisitor
  def initialize(text_renderer:)
    @text_renderer = text_renderer
  end

  def call(node)
    if node.respond_to?(:children)
      visit_element(node)
    else
      visit_text(node)
    end
  end

  private

  attr_reader :text_renderer

  def visit_element(node)
    node.children.each { |child| call(child) }

    node
  end

  def visit_text(node)
    node.rows.each { |row|
      text_renderer.call(
        row.content,
        node.x + row.x,
        node.y + row.y,
      )
    }

    node
  end
end