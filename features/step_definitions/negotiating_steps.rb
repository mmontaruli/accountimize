When /^I uncheck this line item$/ do
  uncheck('estimate_line_items_attributes_0_is_enabled')
end

Then /^I should see the line item total "(.*?)"$/ do |line_total|
  find_total = find('td.line_t_price').text
  find_total.should == line_total
end

Given /^"(.*?)" line item is selected$/ do |line_item_name|
  line_item = @estimate.line_items.find_by_name(line_item_name)
  line_item.is_enabled
  line_item.save
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
end

Given /^I am customizing an estimate for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  @estimate = create(:estimate, client_id: @client.id)
  @line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost)
end

Given /^I am reviewing a previously reviewed estimate for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  @estimate = create(:estimate, client_id: @client.id, already_reviewed: true, send_to_contact: @user.id)
  @line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost)
  visit edit_estimate_url(@estimate, subdomain: @user.client.account.subdomain)
end

Given /^I am reviewing an estimate for "(.*?)" for "(.*?)" for the first time$/ do |service_name, service_cost|
  @estimate = create(:estimate, client_id: @client.id, already_reviewed: false, send_to_contact: @user.id)
  @line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost, is_enabled: false)
  visit edit_estimate_url(@estimate, subdomain: @user.client.account.subdomain)
end

When /^I have no negotiations to make$/ do
  find('.estimate-first-step a.next').click
end

When /^I negotiate this by commenting "(.*?)" and countering "(.*?)"$/ do |comment, price|
  click_link "Negotiate"
  find("tr.negotiate_line td.description textarea").set(comment)
  find("tr.negotiate_line td.line_qty input[type=text]").set(1)
  find("tr.negotiate_line td.line_u_price input[type=text]").set(price)
  #click_button("Save")
  find(".estimate-second-step a.next").click
  click_button("Save")
end

When /^I change this line item price to "(.*?)"$/ do |line_price|
  find("input#estimate_line_items_attributes_0_unit_price").set(line_price)
end

When /^I fill in this estimate information$/ do
  select("Google", :from => "estimate_client_id")
  find('input#estimate_line_items_attributes_0_name').set @service_name
  #fill_in 'estimate[line_items_attributes][0][number]', :with => @service_name
  find('input#estimate_line_items_attributes_0_quantity').set 1
  find('input#estimate_line_items_attributes_0_unit_price').set @service_cost
end

Then /^I should see "(.*?)" as the line total$/ do |line_total|
  # find("td.line_t_price").should have_content(line_total)
  first("td.line_t_price").should have_content(line_total)
end

Then /^I should see "(.*?)" as the estimate total$/ do |estimate_total|
  find("td.total_price strong").should have_content(estimate_total)
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
  @estimate = create(:estimate, client_id: @user.client_id, send_to_contact: @user.id)
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

When /^I click on the line item to select it$/ do
  find('tr.line_item').click
end

When /^I confirm these changes and save$/ do
  find('.estimate-second-step a.next').click
  click_button("Save")
end

When /^I click "(.*?)" to go to the second step$/ do |link_text|
  find('.estimate-first-step a.next').click
end

Then /^vendor should receive a new negotiation notification$/ do
  visit log_out_url(subdomain: @user.client.account.subdomain)
  login(@vendor.account.subdomain, @vendor_user.email, @vendor_user.password)
  visit messages_url(subdomain: @vendor.account.subdomain)
  page.should have_content("New negotiation on estimate #")
end
