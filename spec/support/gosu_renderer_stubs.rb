require "gosu_box_renderer"
require "gosu_text_renderer"

def gosu_box_renderer_stub
  GosuBoxRenderer.new(double(:viewport))
    .tap { |tr|
      allow(tr).to receive(:call).and_return(nil)
    }
end

def gosu_text_renderer_stub
  GosuTextRenderer.new(double(:viewport))
    .tap { |tr|
      allow(tr).to receive(:call).and_return(nil)
    }
end
