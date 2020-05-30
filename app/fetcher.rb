require "rest-client"

class Fetcher
  def call(uri)
    RestClient.get(uri).body
  end
end
