require "element"
require "first_child_position_calculator"
require "support/shared_examples/visitor"

RSpec.describe FirstChildPositionCalculator do
  describe "adhering to the visitor-decorating contract" do
    let(:visitor_decorator_class) { FirstChildPositionCalculator }
    let(:other_arguments) { {:parent_node => Element.new} }

    it_behaves_like "a visitor decorator"
  end
end
