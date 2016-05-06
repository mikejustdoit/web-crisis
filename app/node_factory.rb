require "element"
require "text"

class NodeFactory
  def initialize(renderable_types:, parsed_element:)
    @renderable_types = renderable_types
    @parsed_element = parsed_element
  end

  def call
    if is_renderable?
      case parsed_element.name
      when "text"
        parsed_element.content.strip.split("\n").map { |content|
          Text.new(content: content)
        }
      else
        Element.new(children: children)
      end
    end
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
    }.flatten.compact
  end
end
