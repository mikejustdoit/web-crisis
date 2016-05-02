When(/^I request an address$/) do
  @address = "https://lwn.net/"
  visit_address(@address)
end

Then(/^the browser should visit the address$/) do
  expect(a_request(:get, @address)).to have_been_made.once
end

Then(/^the browser should render the web page$/) do
  page_displays_heading("Welcome to LWN.net")
end
