class Link < SimpleDelegator
  def initialize(node, href:)
    @node = node
    @href = href

    super(node)
  end

  attr_reader :href

  def clone_with(**attributes)
    Link.new(
      node.clone_with(**attributes),
      href: attributes.fetch(:href, href),
    )
  end

  private

  attr_reader :node
end
