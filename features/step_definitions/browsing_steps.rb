When(/^I request an address$/) do
  @address = "https://lwn.net/"
  visit_address(@address)
end

When(/^I render it in the browser$/) do
  render_in_browser(@html_input)
end

Then(/^the browser should visit the address$/) do
  expect(a_request(:get, @address)).to have_been_made.once
end

Then(/^the browser should render the web page$/) do
  page_displays_heading("Welcome to LWN.net")
end

Then(/^each element appears to the right of its predecessor$/) do
  elements_are_positioned_left_to_right
end

Then(/^each element appears below its predecessor$/) do
  elements_are_positioned_on_their_own_rows
end

Then(/^their parent fits them all widthwise$/) do
  root_node_is_at_least_as_wide_as_all_of_its_chilren
end

Then(/^their parent fits them all heightwise$/) do
  root_node_is_at_least_as_tall_as_all_of_its_chilren
end
