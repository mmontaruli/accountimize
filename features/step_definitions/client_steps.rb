Given /^I have clients "(.*?)" and "(.*?)"$/ do |client1, client2|
  first_client = create(:client, name: client1, account_id: @user.client.account_id)
  second_client = create(:client, name: client2, account_id: @user.client.account_id)
end

When /^I go to the list of clients$/ do
  visit "http://#{@user.client.account.subdomain}.example.com/clients"
end

Given /^I would like to create a client "(.*?)"$/ do |client_name|
  @client_name = client_name
end

When /^I go to the New Client page$/ do
  visit "http://#{@user.client.account.subdomain}.example.com/clients/new"
end

When /^I fill in and submit my new clients information$/ do
  find("input[placeholder='Client Name']").set @client_name
  click_button('Save')
end

When /^I go to the edit page for this client$/ do
  visit "http://#{@user.client.account.subdomain}.example.com/clients/#{@client.id}/edit"
end

When /^I change the client name to "(.*?)"$/ do |new_client_name|
  find("input[placeholder='Client Name']").set new_client_name
  click_button('Save')
end

When /^I click the delete button next to this client$/ do
  find('a', :href => "#{client_path(@client)}", :text => 'Delete').click
end

When /^I go to any client section$/ do
  @blocked_urls = [
    "http://#{@vendor.account.subdomain}.example.com/clients",
    "http://#{@vendor.account.subdomain}.example.com/clients/#{@user.client.id}/edit",
    "http://#{@vendor.account.subdomain}.example.com/clients/#{@user.client.id}"
  ]
end
