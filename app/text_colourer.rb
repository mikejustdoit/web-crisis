class TextColourer
  def initialize(**_); end

  def call(node, colour: default_colour)
    if node.respond_to?(:href)
      node.clone_with(
        children: node.children.map { |child| call(child, colour: link_colour) },
      )
    elsif node.respond_to?(:children)
      node.clone_with(
        children: node.children.map { |child| call(child, colour: colour) },
      )
    elsif node.respond_to?(:rows)
      node.clone_with(colour: colour)
    else
      node
    end
  end

  private

  def default_colour
    :black
  end

  def link_colour
    :blue
  end
end
