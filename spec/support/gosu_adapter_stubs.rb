require "gosu_box_renderer"
require "gosu_image_calculator"
require "gosu_image_renderer"
require "gosu_text_renderer"
require "gosu_text_calculator"

def gosu_box_renderer_stub
  GosuBoxRenderer.new(double(:viewport))
    .tap { |br|
      allow(br).to receive(:call).and_return(nil)
    }
end

def gosu_image_calculator_stub(returns:)
  GosuImageCalculator.new
    .tap { |ic|
      allow(ic).to receive(:call).and_return(returns)
    }
end

def gosu_image_renderer_stub
  GosuImageRenderer.new(double(:viewport))
    .tap { |ir|
      allow(ir).to receive(:call).and_return(nil)
    }
end

def gosu_text_renderer_stub
  GosuTextRenderer.new(double(:viewport))
    .tap { |tr|
      allow(tr).to receive(:call).and_return(nil)
    }
end

def gosu_text_calculator_stub(returns:)
  GosuTextCalculator.new
    .tap { |tc|
      allow(tc).to receive(:call).and_return(returns)
    }
end
