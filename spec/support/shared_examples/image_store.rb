RSpec.shared_examples "the image store interface" do
  it "exposes a #call method" do
    expect(store).to respond_to(:call)
  end

  it "accepts an image location string and returns an absolute file path" do
    expect(store.call("art.gif")).to match(/art\.gif/)
  end
end
