class ContentType
  class Error < StandardError; end
  class Missing < Error; end
  class NotImplementedError < Error; end

  def initialize(header_value)
    raise Missing if header_value.nil? || header_value.empty?

    @type = header_value.split(";").first
  end

  def match?(accepted_types)
    if accepted_types.join("") =~ /\*/
      raise NotImplementedError.new("ContentType doesn't support wildcards yet")
    end

    accepted_types.include?(type)
  end

  def to_s
    type
  end

  private

  attr_reader :type
end
