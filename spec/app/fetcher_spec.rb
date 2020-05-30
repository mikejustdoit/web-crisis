require "fetcher"
require "rest-client"
require "support/shared_examples/fetcher"
require "webmock/rspec"

RSpec.describe Fetcher do
  describe "a successful fetch" do
    let(:http_client) { RestClient }

    let(:response_status) { "200 OK" }
    let(:response_content_type) { "text/html; charset=ISO-8859-1" }
    let(:response_headers) { "Content-Type: #{response_content_type}" }
    let(:response_body) { "<!doctype html><html><head><meta content=\"text/html; charset=UTF-8\" http-equiv=\"Content-Type\"></head><body></body></html>\n" }
    let(:raw_response) {
      "HTTP/1.1 #{response_status}\n#{response_headers}\n\n#{response_body}"
    }

    let(:uri) { "https://www.example.com" }
    let(:supported_mime_types) { %w{text/html} }
    subject(:fetcher) { Fetcher.new(http_client) }

    before do
      allow(http_client).to receive(:get).and_call_original

      stub_request(:get, uri).to_return(raw_response)
    end

    include_examples "the fetcher interface"

    it "delegates to the HTTP client" do
      fetcher.call(uri, accept: supported_mime_types)

      expect(http_client).to have_received(:get).with(uri)
    end

    it "returns the response body" do
      expect(
        fetcher.call(uri, accept: supported_mime_types)
      ).to eq(response_body)
    end
  end
end
