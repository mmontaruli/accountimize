When /^I uncheck this line item$/ do
  uncheck('estimate_line_items_attributes_0_is_enabled')
end

Then /^I should see the line item total "(.*?)"$/ do |line_total|
  find_total = find('td.line_t_price').text
  find_total.should == line_total
end

Given /^I am customizing an estimate for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  @estimate = create(:estimate, client_id: @client.id)
  @line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost)
end

When /^I negotiate this by commenting "(.*?)" and countering "(.*?)"$/ do |comment, price|
  visit edit_estimate_url(@estimate, subdomain: @user.client.account.subdomain)
  click_link "Actions"
  click_link "Negotiate"
  find("textarea[id^='estimate_line_items_attributes_0_negotiate_lines_attributes'][id$='description']").set(comment)
  find("input[id^='estimate_line_items_attributes_0_negotiate_lines_attributes'][id$='line_qty']").set(1)
  find("input[id^='estimate_line_items_attributes_0_negotiate_lines_attributes'][id$='line_price']").set(price)
  click_button("Save")
end

Then /^I should see "(.*?)" as a negotiation in the Edit Estimate page$/ do |price|
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
  page.should have_content(price)
end

Given /^they have counter\-offered for "(.*?)"$/ do |price|
  client_user = create(:user, client_id: @client.id)
  line_item = @estimate.line_items(:first)[0]
  negotiate_line = create(:negotiate_line, line_item_id: line_item.id, line_price: price, user_negotiating: client_user.email)
end

When /^I accept this line item$/ do
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
  check('estimate_line_items_attributes_0_negotiate_lines_attributes_0_is_accepted')
end

Then /^I should see this line item priced at "(.*?)"$/ do |new_price|
  find('td.line_t_price').text.should == new_price
end

Given /^I am customizing an estimate$/ do
  @estimate = create(:estimate, client_id: @user.client_id)
  @line_item = create(:line_item, estimate_id: @estimate.id)
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
end

Given /^all line items on this estimate have been accepted$/ do
  @line_item.is_accepted = true
  @line_item.save
end

When /^I click on the accept estimate button$/ do
  check('estimate[is_accepted]')
end

Given /^no line items have been accepted or negotiated$/ do
end

Then /^vendor should receive a new negotiation notification$/ do
  visit log_out_url(subdomain: @user.client.account.subdomain)
  login(@vendor.account.subdomain, @vendor_user.email, @vendor_user.password)
  visit messages_url(subdomain: @vendor.account.subdomain)
  page.should have_content("New negotiation on estimate #")
end
