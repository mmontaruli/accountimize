Given /^I have clients "(.*?)" and "(.*?)"$/ do |client1, client2|
  first_client = create(:client, name: client1, account_id: @user.client.account_id, users_attributes: [attributes_for(:user)])
  second_client = create(:client, name: client2, account_id: @user.client.account_id, users_attributes: [attributes_for(:user)])
end

When /^I go to the list of clients$/ do
  visit clients_url(:subdomain => @user.client.account.subdomain)
end

Given /^I would like to create a client "(.*?)"$/ do |client_name|
  @client_name = client_name
end

Given /^they have a contact "(.*?)"$/ do |contact_email|
  @contact_email = contact_email
end

When /^I go to the New Client page$/ do
  visit new_client_url(:subdomain => @user.client.account.subdomain)
end

When /^I fill in and submit my new clients information$/ do
  find("input[placeholder='Client Name']").set @client_name
  find("input[placeholder='Email Address']").set @contact_email
  click_button('Save')
end

When /^I go to the edit page for this client$/ do
  visit edit_client_url(@client, :subdomain => @user.client.account.subdomain)
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
    clients_url(:subdomain => @vendor.account.subdomain),
    edit_client_url(@user.client, :subdomain => @vendor.account.subdomain),
    client_url(@user.client, :subdomain => @vendor.account.subdomain)
  ]
end
