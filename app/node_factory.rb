require "element"
require "text"

class NodeFactory
  ELEMENT_TYPES = %w{
    a body blockquote code del div em h1 h2 h3 h4
    h5 h6 html li ol p pre strong table td tr ul
  }

  OTHER_NODE_TYPES = %w{ text }

  def initialize(parsed_element)
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

  attr_reader :parsed_element

  def is_renderable?
    renderable_types.include?(parsed_element.name)
  end

  def children
    parsed_element.children.map { |child|
      NodeFactory.new(child).call
    }.flatten.compact
  end

  def renderable_types
    ELEMENT_TYPES + OTHER_NODE_TYPES
  end
end
