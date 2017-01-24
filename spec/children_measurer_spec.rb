require "box"
require "children_measurer"

RSpec.describe ChildrenMeasurer do
  subject(:measurer) { ChildrenMeasurer.new }

  let(:first_row) { [ Box.new(x: 100, y: 100, width: 10, height: 20) ] }
  let(:second_row) { [ Box.new(x: 100, y: 120, width: 10, height: 20) ] }
  let(:third_row) {
    [
      Box.new(x: 100, y: 140, width: 10, height: 20),
      Box.new(x: 110, y: 140, width: 10, height: 20),
      Box.new(x: 120, y: 140, width: 10, height: 20),
    ]
  }
  let(:last_row) { [ Box.new(x: 100, y: 160, width: 10, height: 20) ] }

  let(:children) { first_row + second_row + third_row + last_row }

  describe "measuring the total width" do
    let(:total_width_of_third_row) { third_row.map(&:width).reduce(0, &:+) }

    before do
      @width, _ = measurer.call(children)
    end

    it "takes the width of the longest row" do
      expect(@width).to eq(total_width_of_third_row)
    end
  end

  describe "measuring the total height" do
    let(:total_height_of_all_rows) {
      first_row.first.height + second_row.first.height +
      third_row.first.height + last_row.first.height
    }

    before do
      _, @height = measurer.call(children)
    end

    it "takes the height of all the rows" do
      expect(@height).to eq(total_height_of_all_rows)
    end
  end

  describe "handling leaf nodes" do
    let(:children) { [] }

    before do
      @width, @height = measurer.call(children)
    end

    it "defaults to 0 width" do
      expect(@width).to eq(0)
    end

    it "defaults to 0 height" do
      expect(@height).to eq(0)
    end
  end
end
