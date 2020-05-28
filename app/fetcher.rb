class Fetcher
  def initialize(http_client)
    @http_client = http_client
  end

  def call(uri)
    http_client.get(uri).body
  end

  private

  attr_reader :http_client
end
