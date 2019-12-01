class RandomUri
  def initialize
    @uri = scheme + domain + path
  end

  def to_s
    uri
  end

  private

  attr_reader :uri

  def scheme
    ["https://", "http://"].sample
  end

  def domain
    [subdomain, hostname, tld].compact.join(".")
  end

  def subdomain
    [domain_word, nil].sample
  end

  def hostname
    (rand(3) + 1).times.map { domain_word }.join("-")
  end

  def tld
    %w{ com biz info name net org io co }.sample
  end

  def path
    "/" + rand(5).times.map { domain_word }.join("/")
  end

  def domain_word
    word(min: 3, max: 12)
  end

  def word(min:, max:)
    length = rand(max - min + 1) + min

    letters.sample(length).join("")
  end

  def letters
    @letters ||= ((%w{ a e i o u } * 6) + (("a".."z").to_a * 2)).shuffle
  end
end
