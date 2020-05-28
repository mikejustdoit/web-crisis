class OfflineHtmlFetcher
  def initialize(body)
    @body = body
  end

  def call(uri, accept:)
    body
  end

  private

  attr_reader :body
end
