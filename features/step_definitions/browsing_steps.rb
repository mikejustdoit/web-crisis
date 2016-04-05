Given(/^I have launched the web browser$/) do
  launch_browser
end

When(/^I enter an address$/) do
  @address = "https://lwn.net/"
  enter_address(@address)
end

When(/^I click "go"$/) do
  click_go
end

Then(/^the browser should visit the address$/) do
  expect(engine).to have_received(:visit).with(@address)
end
