require "engine"
require "fetcher"
require "gui_window"

module GuiWorld
  def browser
    @browser ||= begin
      allow(engine).to receive(:visit).and_call_original
      GuiWindow.new(engine)
    end
  end

  def engine
    @engine ||= Engine.new(Fetcher.new)
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
