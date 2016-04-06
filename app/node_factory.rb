require "node"

class NodeFactory
  def initialize(renderable_types:, parsed_element:)
    @renderable_types = renderable_types
    @parsed_element = parsed_element
  end

  def call
    Node.new(children: children) if is_renderable?
  end

  private

  attr_reader :renderable_types, :parsed_element

  def is_renderable?
    renderable_types.include?(parsed_element.name)
  end

  def children
    parsed_element.children.map { |child|
      NodeFactory.new(
        renderable_types: renderable_types,
        parsed_element: child,
      ).call
    }.compact
  end
end
