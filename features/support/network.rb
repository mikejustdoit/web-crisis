require "webmock/cucumber"

WebMock.disable_net_connect!

def raw_responses
  {
    "https://lwn.net/" => -> { File.new("features/support/lwn-raw-response.txt") },
    "https://static.lwn.net/images/logo/barepenguin-70.png" => -> { File.new("features/support/lwn-logo-barepenguin-70-raw-response.txt") },
    "https://static.lwn.net/images/lcorner-ss.png" => -> { File.new("features/support/lwn-lcorner-ss-raw-response.txt") },
    "https://static.lwn.net/images/2016/03-carhackers-cover-sm.png" => -> { File.new("features/support/lwn-2016-03-carhackers-cover-sm-raw-response.text") },
    "https://en.wikipedia.org/wiki/Hyperlink" => -> { File.new("features/support/wikipedia-hyperlink-raw-response.txt") },
    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Hyperlink-Wikipedia.svg/250px-Hyperlink-Wikipedia.svg.png" => -> { File.new("features/support/wikipedia-hyperlink-pointer-over-link-raw-response.txt") },
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Sistema_hipertextual.jpg/220px-Sistema_hipertextual.jpg" => -> { File.new("features/support/wikipedia-hyperlink-linked-documents-raw-response.txt") },
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Wiki-linking.png/220px-Wiki-linking.png" => -> { File.new("features/support/wikipedia-hyperlink-mediawiki-link-raw-response.txt") },
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/SRI_ARC_Engelbart_Nov_1969.jpg/220px-SRI_ARC_Engelbart_Nov_1969.jpg" => -> { File.new("features/support/wikipedia-hyperlink-engelbart-sri-raw-response.txt") },
    "https://en.wikipedia.org/static/images/footer/wikimedia-button.png" => -> { File.new("features/support/wikipedia-hyperlink-wikimedia-button-raw-response.txt") },
    "https://en.wikipedia.org/static/images/footer/poweredby_mediawiki_88x31.png" => -> { File.new("features/support/wikipedia-hyperlink-poweredby-mediawiki-raw-response.txt") },
    "https://en.wikipedia.org/wiki/Computing" => -> { File.new("features/support/wikipedia-computing-raw-response.txt") },
  }
end

Before do
  raw_responses.each do |uri, raw_response|
    stub_request(:get, uri).to_return { raw_response.call }
  end
end
