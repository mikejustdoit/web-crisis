require "content_type"

class Fetcher
  class Error < StandardError; end

  def initialize(http_client)
    @http_client = http_client
  end

  def call(uri, accept:)
    begin
      response = http_client.get(uri, accept: accept.join(", "))
    rescue => e
      raise Error.new(e.message)
    end

    begin
      content_type = ContentType.new(response.headers[:content_type])
    rescue
      raise Error.new("Response is missing Content-Type header")
    end

    unless content_type.match?(accept)
      raise Error.new("Content-Type #{content_type} doesn't satisfy Accept")
    end

    response.body
  end

  private

  attr_reader :http_client
end
