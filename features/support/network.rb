require "vcr"
require "webmock/cucumber"

WebMock.disable_net_connect!

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = { update_content_length_header: true }

  allow_request_headers = []
  allow_response_headers = %q{ Content-Length Content-Type }

  config.before_record do |interaction, _cassette|
    interaction.request.headers.keep_if { |key, _value|
      allow_request_headers.include?(key)
    }
    interaction.response.headers.keep_if { |key, _value|
      allow_response_headers.include?(key)
    }
  end
end
