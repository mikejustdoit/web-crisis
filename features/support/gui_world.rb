require "engine"
require "fetcher"
require "gui_window"
require "thread"

module GuiWorld
  def browser
    @browser ||= GuiWindow.new(
      Engine.new(Fetcher.new),
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
    expect(text_rendering_thing).to have_received(:draw_text).with(/#{text}/)
  end

  def text_rendering_thing
    double(:text_rendering_thing, :draw_text => nil)
  end
end

World(GuiWorld)

After do
  browser.close if @browser
end
