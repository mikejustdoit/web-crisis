require "offline_html_fetcher"
require "support/shared_examples/fetcher"

RSpec.describe OfflineHtmlFetcher do
  describe "a successful 'fetch'" do
    let(:response_body) { "<!doctype html><html><head><meta content=\"text/html; charset=UTF-8\" http-equiv=\"Content-Type\"></head><body></body></html>\n" }

    let(:uri) { "really://doesn't.matter" }
    let(:supported_mime_types) { %w{text/html} }
    subject(:fetcher) { OfflineHtmlFetcher.new(response_body) }

    include_examples "the fetcher interface"

    it "returns the response body" do
      expect(
        fetcher.call(uri, accept: supported_mime_types)
      ).to eq(response_body)
    end
  end
end
