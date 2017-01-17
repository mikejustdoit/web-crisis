require "node_factory"
require "nokogiri"

class Parser
  def initialize(logger:)
    @logger = logger
  end

  def call(html)
    NodeFactory.new(
      Nokogiri::HTML(html).at_css("html"),
      logger: logger,
    ).call
  end

  private

  attr_reader :logger
end
