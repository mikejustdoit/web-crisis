require "base64"
require "digest"

class DataUri
  def initialize(uri)
    parts = /^data:(image\/[-\+a-z]+)(;base64)?,(.*)$/.match(uri)
    @mime_type = parts[1]
    @is_base64 = parts[2]
    @data = parts[3]
  end

  def write_to_file
    if !File.exist?(name)
      File.open(name, "wb") { |file|
        file.print(
          is_base64? ? Base64.strict_decode64(data) : data
        )
      }
    end
  end

  def name
    File.join(
      ASSETS,
      "#{Digest::SHA256.hexdigest(data)}.#{file_type}",
    )
  end

  private

  attr_reader :mime_type, :is_base64, :data

  def file_type
    mime_type.split("/").last.split(/\W/).first
  end

  def is_base64?
    is_base64
  end
end
