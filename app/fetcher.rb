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

    response.body
  end

  private

  attr_reader :http_client
end
