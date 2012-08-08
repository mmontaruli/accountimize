Given /^I have created invoice number "(.*?)" for them$/ do |invoice_number|
  @invoice = create(:invoice, client_id: @client.id, number: invoice_number)
end

When /^I go to the list of invoices$/ do
  visit "http://#{@user.client.account.subdomain}.example.com/invoices"
end

Given /^I need to invoice this client for "(.*?)"$/ do |service_name|
  @service_name = service_name
end

When /^I go to the New Invoice page$/ do
  visit "http://#{@user.client.account.subdomain}.example.com/invoices/new"
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
  visit "http://#{@user.client.account.subdomain}.example.com/invoices/#{@invoice.id}/edit"
end

When /^I change the invoice line price to "(.*?)" and submit$/ do |new_price|
  find('input#invoice_line_items_attributes_0_unit_price').set new_price
  click_button('Save')
end

Given /^I have an invoice numbered "(.*?)"$/ do |invoice_number|
  @client = create(:client, account_id: @user.client.account_id)
  @invoice = create(:invoice, number: invoice_number, client_id: @client.id)
end

When /^I click the delete button next to this invoice$/ do
  find('a', :href => "#{invoice_path(@invoice)}", :text => 'Delete').click
end

When /^I go to any blocked invoice section$/ do
  @invoice = create(:invoice, client_id: @client.id)
  @blocked_urls = [
    "http://#{@vendor.account.subdomain}.example.com/invoices/new",
    "http://#{@vendor.account.subdomain}.example.com/invoices/#{@invoice.id}/edit"
  ]

end
