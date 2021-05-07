require "offline_engine"

RSpec.describe OFFLINE_ENGINE do
  it "accepts file paths for its URI" do
    engine = OFFLINE_ENGINE.call("<html><h1>Webpage</h1></html>")

    expect { engine.uri = __FILE__ }.not_to raise_error
  end
end
