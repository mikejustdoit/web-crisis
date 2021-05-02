require "uri"

class BuildUri
  class Error < StandardError; end

  def initialize(origin: nil)
    @origin = if origin.nil?
      nil
    else
      URI.parse(origin)
    end
  end

  def call(uri)
    ensure_scheme(
      ensure_host(
        URI.parse(uri)
      )
    ).to_s
  end

  private

  attr_reader :origin

  def ensure_host(uri)
    return uri unless uri.host.nil?

    raise Error if origin.nil?

    origin + uri
  end

  def ensure_scheme(uri)
    return uri unless uri.scheme.nil?

    raise Error if origin.nil?

    uri.tap { |u| u.scheme = origin.scheme }
  end
end
