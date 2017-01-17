require "node_factory"
require "nokogiri"
require "once_per_unique_call"

class Parser
  def initialize(logger:)
    @logger = throttled_logger(logger)
  end

  def call(html)
    NodeFactory.new(
      Nokogiri::HTML(html).at_css("html"),
      logger: logger,
    ).call
  end

  private

  attr_reader :logger

  def throttled_logger(regular_logger)
    OncePerUniqueCall.new(regular_logger)
  end
end
