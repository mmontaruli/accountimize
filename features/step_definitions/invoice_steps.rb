Given /^I have created invoice number "(.*?)" for them$/ do |invoice_number|
  @invoice = create(:invoice, client_id: @client.id, number: invoice_number)
end

When /^I go to the list of invoices$/ do
  visit invoices_url(:subdomain => @user.client.account.subdomain)
end

Given /^I need to invoice this client for "(.*?)"$/ do |service_name|
  @service_name = service_name
end

When /^I go to the New Invoice page$/ do
  visit new_invoice_url(:subdomain => @user.client.account.subdomain)
end

When /^I fill in and submit this invoicing information$/ do
  select("Google", :from => "invoice_client_id")
  find('input#invoice_line_items_attributes_0_name').set @service_name
  find('input#invoice_line_items_attributes_0_quantity').set 1
  find('input#invoice_line_items_attributes_0_unit_price').set @service_cost
  click_button('Save')
end

Given /^I have an invoice created for them for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  @invoice = create(:invoice, client_id: @client.id)
  line_item = create(:line_item, invoice_id: @invoice.id, name: service_name, unit_price: service_cost)
end

When /^I go to the Edit Invoice page$/ do
  visit edit_invoice_url(@invoice, :subdomain => @user.client.account.subdomain)
end

When /^I change the invoice line price to "(.*?)" and submit$/ do |new_price|
  find('input#invoice_line_items_attributes_0_unit_price').set new_price
  click_button('Save')
end

Given /^I have an invoice numbered "(.*?)"$/ do |invoice_number|
  @client = create(:client, account_id: @user.client.account_id, users_attributes: [attributes_for(:user)])
  @invoice = create(:invoice, number: invoice_number, client_id: @client.id)
end

When /^I click the delete button next to this invoice$/ do
  #find('a', :href => "#{invoice_path(@invoice)}", :text => 'Delete').click
  find('a', :text => 'Delete').click
end

When /^I go to any blocked invoice section$/ do
  @invoice = create(:invoice, client_id: @client.id)
  @blocked_urls = [
    new_invoice_url(:subdomain => @vendor.account.subdomain),
    edit_invoice_url(@invoice, :subdomain => @vendor.account.subdomain)
  ]
end

Then /^client should receive a new invoice notification$/ do
  visit log_out_url(subdomain: @user.client.account.subdomain)
  login(@client.account.subdomain, @client_user.email, @client_user.password)
  visit messages_url(subdomain: @client.account.subdomain)
  page.should have_content("New Invoice #")
end
