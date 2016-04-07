require "engine"
require "fetcher"
require "gui_window"

module GuiWorld
  def browser
    @browser ||= GuiWindow.new(Engine.new(Fetcher.new))
  end

  def launch_browser
    browser
  end

  def enter_address(new_address)
    browser.address = new_address
  end

  def click_go
    browser.go
  end

  def page_contains(text)
    expect(text_rendering_thing).to have_received(:draw_text).with(/#{text}/)
  end

  def text_rendering_thing
    double(:text_rendering_thing, :draw_text => nil)
  end
end

World(GuiWorld)
