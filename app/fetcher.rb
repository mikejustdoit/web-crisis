require "rest-client"

class Fetcher
  def call(uri)
    get_body(uri)
  end

  private

  def get_body(uri)
    rest_client.get(uri).body
  end

  def rest_client
    RestClient
  end
end
