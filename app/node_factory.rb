require "box"
require "block_level_element"
require "build_text"
require "element"
require "image"
require "inline_element"
require "link"
require "text"

class NodeFactory
  BLOCK_LEVEL_ELEMENT_TYPES = %w{
    article body blockquote code del div footer h1 h2 h3 h4
    h5 h6 header html li nav ol p pre table td tr ul
  }

  INLINE_ELEMENT_TYPES = %w{
    a b em i img span strong sup
  }

  ELEMENT_TYPES = BLOCK_LEVEL_ELEMENT_TYPES + INLINE_ELEMENT_TYPES

  OTHER_NODE_TYPES = %w{ text }

  def initialize(parsed_element, logger:)
    @parsed_element = parsed_element
    @logger = logger
  end

  def call
    if !is_renderable?
      logger.call("NodeFactory not rendering #{parsed_element.name}")
      return
    end

    case parsed_element.name
    when "text"
      return if parsed_element.content.strip.empty?

      BuildText.new.call(content: parsed_element.content)
    when "img"
      InlineElement.new(Image.new(src: parsed_element["src"]))
    when "a"
      InlineElement.new(
        Link.new(
          Element.new(children: children),
          href: parsed_element["href"],
        )
      )
    when *BLOCK_LEVEL_ELEMENT_TYPES
      BlockLevelElement.new(Element.new(children: children))
    else
      InlineElement.new(Element.new(children: children))
    end
  end

  private

  attr_reader :logger, :parsed_element

  def is_renderable?
    renderable_types.include?(parsed_element.name)
  end

  def children
    parsed_element.children.map { |child|
      NodeFactory.new(
        child,
        logger: logger,
      ).call
    }.flatten.compact
  end

  def renderable_types
    ELEMENT_TYPES + OTHER_NODE_TYPES
  end
end
