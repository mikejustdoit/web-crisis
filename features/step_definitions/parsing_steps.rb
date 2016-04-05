Given(/^the HTML input:$/) do |html|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I run the parser$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

INTEGER_PATTERN = Transform(/^\d+$/) do |n|
  Integer(n)
end

Then(/^the resulting tree should have (#{INTEGER_PATTERN}) nodes$/) do |n|
  pending # Write code here that turns the phrase above into concrete actions
end
