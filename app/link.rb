require "delegate"

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

  def clickable?
    !href.nil? && !href.empty?
  end

  private

  attr_reader :node
end
