require "element"
require "children_positioner"

RSpec.describe ChildrenPositioner do
  subject(:positioner) {
    ChildrenPositioner.new(
      first_child_positioner: first_child_positioner,
      subsequent_child_positioner: subsequent_child_positioner,
    )
  }
  let(:first_child_positioner) { double(:first_child_positioner) }
  let(:subsequent_child_positioner) { double(:subsequent_child_positioner) }

  before do
    allow(first_child_positioner).to receive(:call) { |node, _| node }
    allow(subsequent_child_positioner).to receive(:call) { |node, _| node }
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
      expect(first_child_positioner).to have_received(:call).ordered
      expect(subsequent_child_positioner).to have_received(:call)
        .twice.ordered
    end
  end
end
