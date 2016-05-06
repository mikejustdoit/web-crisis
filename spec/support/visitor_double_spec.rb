require "support/shared_examples/visitor"
require "support/visitor_doubles"

RSpec.describe "drawing_visitor_double" do
  let(:visitor) { drawing_visitor_double }

  it_behaves_like "a visitor"
end

RSpec.describe "layout_visitor_double" do
  let(:visitor) { layout_visitor_double }

  it_behaves_like "a visitor"
end
