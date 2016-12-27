require "gosu_box_renderer"
require "gosu_text_renderer"
require "gosu_text_width_calculator"

def gosu_box_renderer_stub
  GosuBoxRenderer.new(double(:viewport))
    .tap { |br|
      allow(br).to receive(:call).and_return(nil)
    }
end

def gosu_text_renderer_stub
  GosuTextRenderer.new(double(:viewport))
    .tap { |tr|
      allow(tr).to receive(:call).and_return(nil)
    }
end

def gosu_text_width_calculator_stub
  GosuTextWidthCalculator.new
    .tap { |twc|
      allow(twc).to receive(:call).and_return(9000)
    }
end
