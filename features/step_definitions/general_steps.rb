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

def engine
  @engine ||= ONLINE_ENGINE.call
end

def browser
  @browser ||= WindowDouble.new(engine: engine)
end

def visit_address(new_address)
  browser.address = new_address

  browser.go
end

def page_displays_heading(text)
  bounding_boxes = page.bounding_boxes_for_first(text)

  expect(bounding_boxes).not_to be_empty

  bounding_boxes.each do |box|
    expect(browser.in_view?(box)).to be true
  end
end

def page_displays_image(image_address, width:, height:)
  image = page.find_single_image(image_address)

  expect(image.width).to eq(width)
  expect(image.height).to eq(height)
end

def image_is_using_placeholder(image_address)
  image = page.find_single_image(image_address)

  expect(image.filename).to eq(PLACEHOLDER_IMAGE)
  expect(image.width).to eq(100)
  expect(image.height).to eq(100)
end

def page_displays_link(uri)
  link = page.find_single_link(uri)

  expect(link).not_to be_nil
  expect(browser.in_view?(link)).to be true

  expect(link.children).not_to be_empty
  expect(link.children.map(&:colour).uniq).to eq([:blue])
end

def page
  Inspector.new(engine.render_tree)
end

Given("a web page:") do |html|
  @address ||= RandomUri.new.to_s

  stub_request(:get, @address).to_return(
    body: html,
    headers: {"Content-Type" => "text/html"},
  )
end

Given("an {string} image {string}") do |mime_type, image_path|
  @address ||= RandomUri.new.to_s

  stub_request(
    :get,
    URI.parse(@address) + URI.parse(image_path)
  ).to_return(
    body: "TEST IMAGE DATA",
    headers: {"Content-Type" => mime_type},
  )
end

Then(/^the resulting tree has (\d+) nodes$/) do |n|
  expect(engine.render_tree).not_to be_nil
  expect(tree_size(engine.render_tree)).to eq(n)
end

Given("a maximum of {int} words can fit across the viewport") do |words_per_row|
  browser.allow_words_per_row(words_per_row)
end

Given("I'm on the page {string}") do |address|
  visit_address(address)
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

When('I click on {string}') do |link_text|
  text_node = page.bounding_boxes_for_first(link_text).first

  browser.click(text_node.x, text_node.y)
end

Then('the browser visits {string}') do |address|
  expect(a_request(:get, address)).to have_been_made.once
end

Then('the browser renders the heading {string}') do |text|
  page_displays_heading(text)
end

Then(/^the browser visits the address$/) do
  expect(a_request(:get, @address)).to have_been_made.once
end

Then(/^the browser renders the web page$/) do
  page_displays_heading("Welcome to LWN.net")
  page_displays_image(
    "https://static.lwn.net/images/logo/barepenguin-70.png",
    width: 100,
    height: 100,
  )
  page_displays_link("/op/AuthorGuide.lwn")
end

Then("{string} falls back to the placeholder image") do |image_path|
  image_is_using_placeholder(image_path)
end

Then("{string} appears on a single row") do |full_text|
  bounding_boxes = page.bounding_boxes_for_first(full_text)

  expect(bounding_boxes.map(&:y).uniq.size).to eq(1)

  bounding_boxes.sort_by(&:x).each_cons(2) { |a, b|
    expect(b.x).to be >= a.right
  }
end

Then("the text appears over {word} rows") do |_, table|
  texts = table.raw.map(&:first).map(&:strip)

  texts.each do |search_text|
    expect(engine.render_tree.content).to include(search_text)
  end

  expect(
    texts.flat_map { |search_text|
      page.bounding_boxes_for_first(search_text)
    }.map(&:y).uniq.size
  ).to eq(texts.size)
end

Then("the whole thing still reads exactly {string}") do |whole_page_text|
  expect(engine.render_tree.content).to eq(whole_page_text)
end
