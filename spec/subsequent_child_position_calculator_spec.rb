require "element"
require "subsequent_child_position_calculator"
require "support/shared_examples/visitor"

RSpec.describe SubsequentChildPositionCalculator do
  describe "adhering to the visitor-decorating contract" do
    let(:visitor_decorator_class) { SubsequentChildPositionCalculator }
    let(:other_arguments) { {:preceding_sibling_node => Element.new} }

    it_behaves_like "a visitor decorator"
  end
end
