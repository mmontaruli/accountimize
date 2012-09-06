Given /^I have created estimate number "(.*?)" for them$/ do |estimate_number|
  @estimate = create(:estimate, number: estimate_number, client_id: @client.id)
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
  @estimate = create(:estimate, client_id: @client.id)
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
  @client = create(:client, account_id: @user.client.account_id)
  @estimate = create(:estimate, number: estimate_number, client_id: @client.id)
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
  @estimate = create(:estimate, client_id: @client.id)
  line_item = create(:line_item, estimate_id: @estimate.id)
end

Then /^client should receive a new estimate notification$/ do
  visit log_out_url(subdomain: @user.client.account.subdomain)
  login(@client.account.subdomain, @client_user.email, @client_user.password)
  visit messages_url(subdomain: @client.account.subdomain)
  page.should have_content("New Estimate #")
end


