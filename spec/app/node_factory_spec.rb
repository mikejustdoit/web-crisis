require "node_factory"
require "support/nokogiri_stubs"

RSpec.describe NodeFactory do
  describe "handling text nodes" do
    it "ignores standalone runs of whitespace" do
      parsed_element = parsed_text_node("  \n  ")
      factory = NodeFactory.new(parsed_element, logger: ->(_) {})

      expect(factory.call).to be_nil
    end

    it "creates a single Text" do
      parsed_element = parsed_text_node("  \n  abc  \n def \n")
      factory = NodeFactory.new(parsed_element, logger: ->(_) {})

      expect(factory.call).to be_a(Text)
    end
  end
end
