class FailingFetcher
  class Error < StandardError; end

  def call(uri)
    raise Error.new("Failed to fetch '#{uri}'")
  end
end
