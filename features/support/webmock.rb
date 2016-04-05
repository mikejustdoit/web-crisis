require "webmock/cucumber"

WebMock.disable_net_connect!

def raw_responses
  {
    "https://lwn.net/" => -> { File.new("features/support/lwn-raw-response.txt") },
  }
end

Before do
  raw_responses.each do |uri, raw_response|
    stub_request(:get, uri).to_return { raw_response.call }
  end
end
