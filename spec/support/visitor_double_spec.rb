require "support/shared_examples/visitor_double"
require "support/visitor_doubles"

RSpec.describe "drawing_visitor_double" do
  let(:drawing_visitor) { drawing_visitor_double }

  it_behaves_like "a drawing visitor"
end

RSpec.describe "layout_visitor_double" do
  let(:layout_visitor) { layout_visitor_double }

  it_behaves_like "a layout visitor"
end
