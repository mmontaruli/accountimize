Given /^I have created estimate number "(.*?)" for them$/ do |estimate_number|
  client_user = create(:user, client_id: @client.id)
  @estimate = create(:estimate, number: estimate_number, client_id: @client.id, send_to_contact: client_user.id)
end

When /^I go to the list of estimates$/ do
  visit estimates_url(:subdomain => @user.client.account.subdomain)
end

Given /^The client would like a quote for "(.*?)"$/ do |service_name|
  @service_name = service_name
end

Given /^My services cost "(.*?)"$/ do |service_cost|
  @service_cost = service_cost
end

When /^I go to the New Estimate page$/ do
  visit new_estimate_url(:subdomain => @user.client.account.subdomain)
end

When /^I fill in and submit this estimate information$/ do
  select("Google", :from => "estimate_client_id")
  select(@specific_client_user.email, :from => "estimate_send_to_contact")
  find('input#estimate_line_items_attributes_0_name').set @service_name
  find('input#estimate_line_items_attributes_0_quantity').set 1
  find('input#estimate_line_items_attributes_0_unit_price').set @service_cost
  click_button('Save')
end

Then /^I should see "(.*?)" line items$/ do |num|
  matching = all('table.line_items tr.line_item')
  matched = matching.size
  matched.should == Integer(num)
end

Given /^I have an estimate created for them for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  client_user = create(:user, client_id: @client.id)
  @estimate = create(:estimate, client_id: @client.id, send_to_contact: client_user.id)
  line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost)
end

Given /^it has another line item for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost)
end

When /^I go to the Edit Estimate page$/ do
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
end

When /^I change the price to "(.*?)" and submit$/ do |new_price|
  find('input#estimate_line_items_attributes_0_unit_price').set new_price
  click_button('Save')
end

Given /^I have an estimate numbered "(.*?)"$/ do |estimate_number|
  @client = create(:client, account_id: @user.client.account_id, users_attributes: [attributes_for(:user)])
  # client_user = create(:user, client_id: @client.id)
  client_user = @client.users.first
  @estimate = create(:estimate, number: estimate_number, client_id: @client.id, send_to_contact: client_user.id)
end

When /^I click the delete button next to this estimate$/ do
  find('a', :href => "#{estimate_path(@estimate)}", :text => 'Delete').click
end

When /^I go to any blocked estimate section$/ do
  @blocked_urls = [
    new_estimate_url(:subdomain => @vendor.account.subdomain)
  ]
end

Given /^I have created an estimate for this client$/ do
  client_user = create(:user, client_id: @client.id)
  @estimate = create(:estimate, client_id: @client.id, send_to_contact: client_user.id)
  line_item = create(:line_item, estimate_id: @estimate.id)
end

Then /^client should receive a new estimate notification$/ do
  visit log_out_url(subdomain: @user.client.account.subdomain)
  login(@client.account.subdomain, @client_user.email, @client_user.password)
  visit messages_url(subdomain: @client.account.subdomain)
  page.should have_content("New Estimate #")
end

Given /^the vendor has sent me an estimate$/ do
  @estimate = create(:estimate, client_id: @user.client.id, send_to_contact: @user.id)
end

Given /^the estimate has a line item for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost, is_enabled: false)
end

Given /^the estimate has a selected line item for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost, is_enabled: true)
end

Given /^the estimate has a deselected line item for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost, is_enabled: false)
end

Given /^I am reviewing the estimate for the first time$/ do
  @estimate.already_reviewed = false
  @estimate.save
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
end

Given /^I am reviewing an estimate for the second time$/ do
  @estimate.already_reviewed = true
  @estimate.save
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
end

When /^I click on the "(.*?)" line item to select it$/ do |service_name|
  find('tr.line_item', :text => service_name).click
end

Then /^I should see "(.*?)" in the deselected table$/ do |service_name|
  line_item = @estimate.line_items.find_by_name(service_name)
  page.find("table.second_step tbody.deselected tr.line-id-#{line_item.id} td.line_name input").value.should eq service_name
end

Then /^the estimate should total "(.*?)"$/ do |estimate_total|
  page.find("table.second_step tbody.selected tr.total_line td.total_price strong").should have_content(estimate_total)
end

Then /^I should see "(.*?)" in the selected table$/ do |service_name|
  line_item = @estimate.line_items.find_by_name(service_name)
  page.find("table.second_step tbody.selected tr.line-id-#{line_item.id} td.line_name input").value.should eq service_name
end

When /^I drag the "(.*?)" line item to the top of the estimate$/ do |line_item_name|
  drop_place = page.find(:css, 'table.second_step tbody tr:first')
  line_item = @estimate.line_items.find_by_name(line_item_name)
  page.find("table.second_step tr.line-id-#{line_item.id}").drag_to(drop_place)
end

When /^I drag the "(.*?)" line item to the deselected area$/ do |line_item_name|
  drop_place = page.find(:css, 'table.second_step tbody.deselected tr:first')
  line_item = @estimate.line_items.find_by_name(line_item_name)
  page.find("table.second_step tr.line-id-#{line_item.id}").drag_to(drop_place)
end

When /^I drag the "(.*?)" line item to the selected area$/ do |line_item_name|
  drop_place = page.find(:css, 'table.second_step tbody.selected tr:first')
  line_item = @estimate.line_items.find_by_name(line_item_name)
  page.find("table.second_step tr.line-id-#{line_item.id}").drag_to(drop_place)
end

Then /^the "(.*?)" line item should appear deselected on the estimate view page$/ do |line_item_name|
  visit estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
  line_item = @estimate.line_items.find_by_name(line_item_name)
  line_item.is_enabled.should == false
end

Then /^the "(.*?)" line item should appear selected on the estimate view page$/ do |line_item_name|
  visit estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
  line_item = @estimate.line_items.find_by_name(line_item_name)
  line_item.is_enabled.should == true
end

Then /^the line item "(.*?)" should be at the top of the estimate$/ do |line_item_name|
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
  page.find("table.second_step tbody tr:first td.line_name input").value.should eq line_item_name
end

