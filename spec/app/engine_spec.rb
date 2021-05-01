require "box"
require "build_text"
require "drawing_visitors"
require "element"
require "engine"
require "fetcher"
require "inline_element"
require "layout_visitors"
require "link"
require "parser"

RSpec.describe Engine do
  subject(:engine) {
    Engine.new(
      drawing_visitors: drawing_visitors,
      fetcher: fetcher,
      image_store_factory: image_store_factory,
      layout_visitors: layout_visitors,
      parser: parser,
    )
  }

  let(:drawing_visitors) { object_double(DRAWING_VISITORS, :visit => a_tree) }
  let(:fetcher) { instance_double("Fetcher", :call => "<html></html>") }
  let(:image_store_factory) { double(:image_store_factory, :call => nil) }
  let(:layout_visitors) { object_double(LAYOUT_VISITORS, :visit => nil) }
  let(:parser) { Parser.new.tap { |p| allow(p).to receive(:call) } }

  let(:a_tree) { Element.new }

  def render
    engine.uri = "http://www.drchip.org/astronaut/vim/index.html"

    engine.render(
      viewport_width: 640,
      viewport_height: 480,
      text_calculator: double(:text_calculator),
      image_calculator: double(:image_calculator),
      box_renderer: double(:box_renderer),
      image_renderer: double(:image_renderer),
      text_renderer: double(:text_renderer),
    )
  end

  it "fetches its current URI and parses it" do
    render

    expect(fetcher).to have_received(:call)
    expect(parser).to have_received(:call)
  end

  it "builds its image store with the current 'origin' URI" do
    render

    expect(image_store_factory).to have_received(:call)
      .with(origin: "http://www.drchip.org/astronaut/vim/index.html")
  end

  it "lays out and draws the parsed render tree and returns it" do
    returned_tree = render

    expect(layout_visitors).to have_received(:visit)
    expect(drawing_visitors).to have_received(:visit)

    expect(returned_tree).to eq(a_tree)
  end

  describe "handling a click" do
    context "when the target is a link with an href" do
      it "notifies the GuiWindow that a redraw is required" do
        gui_window = double(:gui_window, needs_redraw!: nil)

        allow(drawing_visitors).to receive(:visit).and_return(
          InlineElement.new(
            Link.new(
              Element.new(
                box: Box.new(x: 0, y: 0, width: 100, height: 100),
                children: [BuildText.new.call(content: "Click here")],
              ),
              href: "https://https://en.wikipedia.org/wiki/Hyperlink",
            )
          )
        )

        render

        engine.click(0, 0, gui_window)

        expect(gui_window).to have_received(:needs_redraw!)
      end
    end

    context "when the target doesn't link to anywhere" do
      it "doesn't do anything" do
        gui_window = double(:gui_window, needs_redraw!: nil)

        render

        engine.click(0, 0, gui_window)

        expect(gui_window).not_to have_received(:needs_redraw!)
      end
    end
  end
end
