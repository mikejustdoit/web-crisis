require "drawing_visitor"
require "engine"
require "fetcher"
require "gosu_text_renderer"
require "gui_window"
require "parser"
require "root_node_dimensions_setter"
require "thread"

module GuiWorld
  def browser
    @browser ||= GuiWindow.new(
      Engine.new(
        fetcher: Fetcher.new,
        drawing_visitor_factory: drawing_visitor_factory,
        layout_visitor_factory: layout_visitor_factory,
        parser: Parser.new,
      ),
      draw_callback,
    )
  end

  def draw_callback
    -> { Thread.exit }
  end

  def launch_browser
    @browser_thread = Thread.new do
      spy_text_renderer

      browser.show
    end
  end

  def enter_address(new_address)
    browser.address = new_address
  end

  def click_go
    browser.go

    @browser_thread.join
  end

  def page_contains(text)
    expect(text_renderer).to have_received(:call).with(/#{text}/)
  end

  def drawing_visitor_factory
    DrawingVisitor.method(:new)
  end

  def spy_text_renderer
    text_renderer
  end

  def text_renderer
    @text_renderer ||= begin
      GosuTextRenderer.new.tap { |tr|
        allow(GosuTextRenderer).to receive(:new).and_return(tr)
        allow(tr).to receive(:call).and_call_original
      }
    end
  end

  def layout_visitor_factory
    RootNodeDimensionsSetter.method(:new)
  end
end

World(GuiWorld)

After do
  browser.close if @browser
end
