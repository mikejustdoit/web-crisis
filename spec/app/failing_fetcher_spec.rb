require "failing_fetcher"

RSpec.describe FailingFetcher do
  subject(:fetcher) { FailingFetcher.new }

  it "fails every time" do
    expect {
      fetcher.call("https://www.anything.com")
    }.to raise_error(FailingFetcher::Error, /https:\/\/www\.anything\.com/)
  end
end
