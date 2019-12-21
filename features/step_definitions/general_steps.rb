require "drawing_visitors"
require "inspector"
require "node_counter"
require "node_lister"
require "online_engine"
require "random_uri"
require "window_double"

def tree_size(tree)
  node_counter.call(tree)
end

def node_counter
  NodeCounter.new
end

def browser
  @browser ||= WindowDouble.new(
    engine: ONLINE_ENGINE.call,
    drawing_visitors: DRAWING_VISITORS,
  )
end

def visit_address(new_address)
  browser.address = new_address

  @render_tree = browser.go
end

def page_displays_heading(text)
  node = page.find_nodes_with_text(text).first

  expect(browser.in_view?(node)).to be true
end

def page_displays_image(image_address, width:, height:)
  image = page.find_single_image(image_address)

  expect(image.width).to eq(width)
  expect(image.height).to eq(height)
end

def page_displays_link(uri, content)
  element = page.find_single_element_with_text(content)
  child_text_nodes = page.find_nodes_with_text(content)

  expect(element.href).to eq(uri)
  expect(child_text_nodes.map(&:colour).uniq).to eq([:blue])
end

def page
  Inspector.new(@render_tree)
end

Given("a web page:") do |html|
  @address = RandomUri.new.to_s

  stub_request(:get, @address).to_return(body: html)
end

Then(/^the resulting tree should have (\d+) nodes$/) do |n|
  expect(@render_tree).not_to be_nil
  expect(tree_size(@render_tree)).to eq(n)
end

When("I resize the window so that only {int} words fit across the viewport") do |words_per_row|
  browser.resize_window(allow_words_per_row: words_per_row)
end

When(/^I request an address$/) do
  @address = "https://lwn.net/"
  visit_address(@address)
end

When(/^I render it in the browser$/) do
  visit_address(@address)
end

When("I render the page in the browser") do
  visit_address(@address)
end

Then(/^the browser should visit the address$/) do
  expect(a_request(:get, @address)).to have_been_made.once
end

Then(/^the browser should render the web page$/) do
  page_displays_heading("Welcome to LWN.net")
  page_displays_image(
    "https://static.lwn.net/images/logo/barepenguin-70.png",
    width: 100,
    height: 100,
  )
  page_displays_link("/op/AuthorGuide.lwn", "Write for us")
end

Then("{string} appears on a single row") do |full_text|
  bounding_boxes = page.bounding_boxes_for_first(full_text)

  expect(bounding_boxes.map(&:y).uniq.size).to eq(1)

  bounding_boxes.sort_by(&:x).each_cons(2) { |a, b|
    expect(b.x).to be >= a.right
  }
end

Then("the text appears over {word} rows") do |_, table|
  texts = table.raw.map(&:first)

  texts.each do |search_text|
    expect(@render_tree.content).to include(search_text)
  end

  expect(
    texts.flat_map { |search_text|
      page.bounding_boxes_for_first(search_text)
    }.map(&:y).uniq.size
  ).to eq(texts.size)
end

Then("the whole thing still reads exactly {string}") do |whole_page_text|
  expect(@render_tree.content).to eq(whole_page_text)
end
