class TextDrawingVisitor
  def initialize(text_renderer:, **)
    @text_renderer = text_renderer
  end

  def call(node)
    if node.respond_to?(:children)
      visit_element(node)
    elsif node.respond_to?(:rows)
      visit_text(node)
    else
      node
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
        x: row.x,
        y: row.y,
        colour: node.colour,
      )
    }

    node
  end
end
