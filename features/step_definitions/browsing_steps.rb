Given("a viewport only wide enough for {int} words on each row") do |words_per_row|
  words_and_spaces_per_row = (words_per_row * 2) - 1

  @viewport_width = 100
  @universal_width_for_any_word_or_space = @viewport_width / words_and_spaces_per_row
end

When(/^I request an address$/) do
  @address = "https://lwn.net/"
  visit_address(@address)
end

When(/^I render it in the browser$/) do
  render_in_browser(@html_input)
end

When("the browser renders it") do
  render_in_browser(@html_input)
end

Then(/^the browser should visit the address$/) do
  expect(a_request(:get, @address)).to have_been_made.once
end

Then(/^the browser should render the web page$/) do
  page_displays_heading("Welcome to LWN.net")
  page_displays_image(
    "https://static.lwn.net/images/logo/barepenguin-70.png",
    width: 70,
    height: 81,
  )
  page_displays_link("/op/AuthorGuide.lwn", "Write for us")
end
