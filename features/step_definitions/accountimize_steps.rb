#require "ruby-debug"
Given /^I do not have an account$/ do
end

Given /^my email address is "(.*?)"$/ do |email_address|
  @new_email_address = email_address
end

Given /^my company name is "(.*?)"$/ do |company_name|
  @new_company_name = company_name
  @new_subdomain = company_name.gsub(/\s+/, "").downcase
end

When /^I sign up for a new account$/ do
  visit('/sign_up')
  fill_in('account_name', :with => @new_company_name)
  fill_in('account_subdomain', :with => @new_subdomain)
  find("input[placeholder='Email Address']").set @new_email_address
  find("input[placeholder='Password']").set "ipsum"
  find("input[placeholder='Confirm Password']").set "ipsum"
  click_button('Save')
end

Then /^I should see "(.*?)"$/ do |text|
  page.should have_content(text)
end

Then /^I should not see "(.*?)"$/ do |text|
  page.should_not have_content(text)
end

Given /^I have an account$/ do
  @user = create(:user)
end

When /^I log in$/ do
  login(@user.client.account.subdomain, @user.email, @user.password)
end

Given /^I am logged in$/ do
  login(@user.client.account.subdomain, @user.email, @user.password)
end

Given /^I would like to log out$/ do
end

When /^I click "(.*?)"$/ do |link|
  click_link(link)
end

Given /^I am a vendor$/ do
  if @user
    @user.client.is_account_master = true
    @user.client.save
  end
end

Given /^I am logged in as a vendor$/ do
  @user = create(:user)
  @user.client.is_account_master = true
  @user.client.save
  login(@user.client.account.subdomain, @user.email, @user.password)
end

Given /^I am logged in as a client$/ do
  @vendor = create(:client, is_account_master: true)
  @client = create(:client, account_id: @vendor.account_id)
  @user = create(:user, client_id: @client.id)
  login(@vendor.account.subdomain, @user.email, @user.password)
end

Given /^I have clients "(.*?)" and "(.*?)"$/ do |client1, client2|
  first_client = create(:client, name: client1, account_id: @user.client.account_id)
  second_client = create(:client, name: client2, account_id: @user.client.account_id)
end

Given /^I have a client named "(.*?)"$/ do |client|
  @client = create(:client, name: client, account_id: @user.client.account_id)
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

Then /^I should be redirected to the account dashboard$/ do
  @blocked_urls.each do |url|
    visit url
    find('h4').should have_content('Account Dashboard')
  end
end

Given /^I have created estimate number "(.*?)" for them$/ do |estimate_number|
  @estimate = create(:estimate, number: estimate_number, client_id: @client.id)
end

When /^I go to the list of estimates$/ do
  visit "http://#{@user.client.account.subdomain}.example.com/estimates"
end

module LoginSteps
  def login(subdomain, name, password)
    visit "http://#{subdomain}.example.com/log_in"
    find("input[placeholder='Email Address']").set name
    find("input[placeholder='Password']").set password
    click_button('Log In')
  end
end

World(LoginSteps)