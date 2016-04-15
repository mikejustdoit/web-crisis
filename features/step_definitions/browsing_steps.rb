Given(/^I have launched the web browser$/) do
end

When(/^I enter an address$/) do
  @address = "https://lwn.net/"
end

When(/^I click "go"$/) do
  visit_address(@address)
end

Then(/^the browser should visit the address$/) do
  expect(a_request(:get, @address)).to have_been_made.once
end

Then(/^the browser should render the web page$/) do
  page_contains("Welcome to LWN.net")
end
