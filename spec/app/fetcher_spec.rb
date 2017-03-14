require "fetcher"
require "webmock/rspec"

RSpec.describe Fetcher do
  describe "a successful fetch" do
    let(:response_body) { "<!doctype html><html><head><meta content=\"text/html; charset=UTF-8\" http-equiv=\"Content-Type\"></head><body></body></html>\n" }
    let(:raw_response) { "HTTP/1.1 200 OK\nContent-Type: text/html; charset=ISO-8859-1\n\n#{response_body}" }

    let(:uri) { "https://www.example.com" }
    subject(:fetcher) { Fetcher.new }

    before do
      stub_request(:get, uri).to_return(raw_response)
    end

    it "returns the response body" do
      expect( fetcher.call(uri) ).to eq(response_body)
    end
  end
end
