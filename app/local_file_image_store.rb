require "uri"

class LocalFileImageStore
  FILE_SCHEME_PATTERN = /^file:\/\//

  def [](uri)
    local_file_filename(uri)

  rescue => e
    logger.call("#{e.inspect} || #{uri}")

    PLACEHOLDER_IMAGE
  end

  private

  def local_file_filename(uri)
    without_file_scheme(URI.unescape(uri))
  end

  def without_file_scheme(uri)
    uri.sub(FILE_SCHEME_PATTERN, "")
  end

  def logger
    LOGGER
  end
end
