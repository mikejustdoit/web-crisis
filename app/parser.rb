require "node_factory"
require "nokogiri"

class Parser
  ELEMENT_TYPES = %w{
    a body blockquote code del div em h1 h2 h3 h4
    h5 h6 html li ol p pre strong table td tr ul
  }

  OTHER_NODE_TYPES = %w{ text }

  def call(html)
    NodeFactory.new(
      renderable_types: renderable_types,
      parsed_element: Nokogiri::HTML(html).at_css("html")
    ).call
  end

  private

  def renderable_types
    ELEMENT_TYPES + OTHER_NODE_TYPES
  end
end
