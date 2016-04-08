require "drawing_visitor"
require "engine"
require "fetcher"
require "gosu_box_renderer"
require "gosu_text_renderer"
require "gui_window"
require "parser"
require "thread"

module GuiWorld
  def browser
    @browser ||= GuiWindow.new(
      Engine.new(
        fetcher: Fetcher.new,
        drawing_visitor: drawing_visitor,
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

  def drawing_visitor
    DrawingVisitor.new(
      box_renderer: box_renderer,
      text_renderer: text_renderer,
    )
  end

  def text_renderer
    @text_renderer ||= begin
      GosuTextRenderer.new.tap { |tr|
        allow(tr).to receive(:call).and_call_original
      }
    end
  end

  def box_renderer
    GosuBoxRenderer.new
  end
end

World(GuiWorld)

After do
  browser.close if @browser
end
