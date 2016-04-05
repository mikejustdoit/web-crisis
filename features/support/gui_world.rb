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
end

World(GuiWorld)
