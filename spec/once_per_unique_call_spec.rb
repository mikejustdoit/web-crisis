require "once_per_unique_call"

RSpec.describe OncePerUniqueCall do
  subject(:callable) { OncePerUniqueCall.new(protected_callable) }
  let(:protected_callable) { double(:protected_callable, :call => nil) }

  describe "receiving an argument for the first time" do
    before do
      callable.call("boo")
      callable.call("hoo")
    end

    it "only invokes its protected internal callable once for each argument" do
      expect(protected_callable).to have_received(:call).with("boo").once
      expect(protected_callable).to have_received(:call).with("hoo").once
    end
  end

  describe "receiving an argument more than once" do
    before do
      callable.call("boo")
      callable.call("boo")
      callable.call("hoo")
      callable.call("hoo")
    end

    it "only invokes its protected internal callable once for each argument" do
      expect(protected_callable).to have_received(:call).with("boo").once
      expect(protected_callable).to have_received(:call).with("hoo").once
    end
  end
end
