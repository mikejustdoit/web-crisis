require "node_factory"
require "nokogiri"

class Parser
  def call(html)
    NodeFactory.new(
      Nokogiri::HTML(html).at_css("html"),
    ).call
  end
end
