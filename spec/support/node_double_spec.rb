require "support/shared_examples/node"
require "support/node_double"

RSpec.describe NodeDouble do
  subject(:node) { NodeDouble.new(nick_name: "The Natural") }
  let(:node_specific_attribute) { :nick_name }

  it_behaves_like "a clonable node"
end
