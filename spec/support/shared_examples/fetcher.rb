RSpec.shared_examples "the fetcher interface" do
  it "exposes a #call method" do
    expect(fetcher).to respond_to(:call)
  end

  it "accepts a URI string and returns a response body" do
    expect(fetcher.call(uri)).to match(response_body)
  end
end
