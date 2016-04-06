require "node"

class NodeFactory
  def initialize(parsed_element)
    @parsed_element = parsed_element
  end

  def call
    Node.new(children: children)
  end

  private

  attr_reader :parsed_element

  def children
    parsed_element.children.map { |child| NodeFactory.new(child).call }
  end
end
