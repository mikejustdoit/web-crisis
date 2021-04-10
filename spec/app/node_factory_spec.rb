require "node_factory"
require "support/nokogiri_stubs"

RSpec.describe NodeFactory do
  describe "handling text nodes" do
    it "ignores standalone runs of whitespace" do
      parsed_element = parsed_text_node("  \n  ")
      factory = NodeFactory.new(parsed_element, logger: ->(_) {})

      expect(factory.call).to be_nil
    end

    it "creates a single Text, maintaining its original text content" do
      original_content = "  \n  abc  \n def \n"
      parsed_element = parsed_text_node(original_content.dup)
      factory = NodeFactory.new(parsed_element, logger: ->(_) {})

      node = factory.call
      expect(node).to be_a(Text)
      expect(node.content).to eq(original_content)
    end
  end
end
