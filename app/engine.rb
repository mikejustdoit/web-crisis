class Engine
  def initialize(fetcher)
    @fetcher = fetcher
  end

  def visit(uri)
    fetcher.call(uri)
  end

  private

  attr_reader :fetcher
end
