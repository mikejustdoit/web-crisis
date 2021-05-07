class ScrollPositioner
  def initialize(scroll_y:, **)
    @scroll_y = scroll_y
  end

  def call(node)
    if node.respond_to?(:children)
      node.clone_with(
        children: node.children.map(&method(:call)),
        y: node.y - scroll_y,
      )
    elsif node.respond_to?(:rows)
      node.clone_with(
        rows: node.rows.map(&method(:call)),
        y: node.y - scroll_y,
      )
    else
      node.clone_with(
        y: node.y - scroll_y,
      )
    end
  end

  private

  attr_reader :scroll_y
end
