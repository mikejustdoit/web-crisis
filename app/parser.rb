require "node_factory"
require "nokogiri"
require "once_per_unique_call"

class Parser
  def call(html)
    NodeFactory.new(
      Nokogiri::HTML(html).at_css("html"),
      logger: throttled_logger,
    ).call
  end

  private

  def throttled_logger
    @throttled_logger ||= OncePerUniqueCall.new(LOGGER)
  end
end
