require "gosu_box_renderer"
require "gosu_image_calculator"
require "gosu_image_renderer"
require "gosu_text_renderer"
require "gosu_text_calculator"
require "rspec/expectations"
require "rspec/mocks"

class StubRenderer
  include ::RSpec::Mocks::ExampleMethods

  def initialize(klass)
    @klass = klass
  end

  def call
    instance_double(klass, call: nil)
  end

  private

  attr_reader :klass
end

class StubCalculator
  include ::RSpec::Matchers
  include ::RSpec::Mocks::ExampleMethods

  def initialize(klass)
    @klass = klass
  end

  def call(dimensions)
    expect(dimensions).not_to be_nil
    expect(dimensions.size).to eq(2)
    expect(dimensions.first).to eq(Integer(dimensions.first))
    expect(dimensions.last).to eq(Integer(dimensions.last))

    instance_double(klass, call: dimensions)
  end

  private

  attr_reader :klass
end

def gosu_box_renderer_stub
  StubRenderer.new(GosuBoxRenderer).call
end

def gosu_image_calculator_stub(returns:)
  StubCalculator.new(GosuImageCalculator).call(returns)
end

def gosu_image_renderer_stub
  StubRenderer.new(GosuImageRenderer).call
end

def gosu_text_renderer_stub
  StubRenderer.new(GosuTextRenderer).call
end

def gosu_text_calculator_stub(returns:)
  StubCalculator.new(GosuTextCalculator).call(returns)
end
