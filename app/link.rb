class Link < SimpleDelegator
  def initialize(node, href:)
    @node = node
    @href = href

    super(node)
  end

  def inspect
    "Link<#{node}>"
  end

  def to_s
    inspect
  end

  attr_reader :href

  def clone_with(**attributes)
    Link.new(
      node.clone_with(**attributes),
      href: attributes.fetch(:href, href),
    )
  end

  def clone_with_children(new_children)
    Link.new(
      node.clone_with_children(new_children),
      href: href,
    )
  end

  private

  attr_reader :node
end
