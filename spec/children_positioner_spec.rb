require "element"
require "children_positioner"

RSpec.describe ChildrenPositioner do
  subject(:positioner) {
    ChildrenPositioner.new(
      first_child_position_calculator: first_child_position_calculator,
      subsequent_child_position_calculator: subsequent_child_position_calculator,
    )
  }
  let(:first_child_position_calculator) {
    double(:first_child_position_calculator)
  }
  let(:subsequent_child_position_calculator) {
    double(:subsequent_child_position_calculator)
  }

  before do
    allow(first_child_position_calculator).to receive(:call) { |node, _| node }
    allow(subsequent_child_position_calculator).to receive(:call) { |node, _| node }
  end

  describe "its collaboration" do
    let(:root) { Element.new(children: [first_child, middle_child, last_child]) }
    let(:first_child) { Element.new }
    let(:middle_child) { Element.new }
    let(:last_child) { Element.new }

    before do
      positioner.call(root)
    end

    it "positions first child and subsequent children differently" do
      expect(first_child_position_calculator).to have_received(:call).ordered
      expect(subsequent_child_position_calculator).to have_received(:call)
        .twice.ordered
    end
  end
end
