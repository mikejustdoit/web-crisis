require "webmock/cucumber"

WebMock.disable_net_connect!

def raw_responses
  {
    "https://lwn.net/" => -> { File.new("features/support/lwn-raw-response.txt") },
    "https://static.lwn.net/images/logo/barepenguin-70.png" => -> { File.new("features/support/lwn-logo-barepenguin-70-raw-response.txt") },
    "https://static.lwn.net/images/lcorner-ss.png" => -> { File.new("features/support/lwn-lcorner-ss-raw-response.txt") },
    "https://static.lwn.net/images/2016/03-carhackers-cover-sm.png" => -> { File.new("features/support/lwn-2016-03-carhackers-cover-sm-raw-response.text") },
  }
end

Before do
  raw_responses.each do |uri, raw_response|
    stub_request(:get, uri).to_return { raw_response.call }
  end
end
