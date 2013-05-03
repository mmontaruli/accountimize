Then /^I should see "(.*?)"$/ do |text|
  page.should have_content(text)
end

Then /^I should not see "(.*?)"$/ do |text|
  page.should_not have_content(text)
end

When /^I click "(.*?)"$/ do |link|
  click_link(link)
end

When /^I click the "(.*?)" button$/ do |button|
  click_button(button)
end

Given /^I am logged in as a vendor$/ do
  # @user = create(:user)
  # @user.client.is_account_master = true
  # @user.client.save
  vendor = create(:client, is_account_master: true, users_attributes: [attributes_for(:user)])
  @user = vendor.users.first
  login(@user.client.account.subdomain, @user.email, @user.password)
end

Given /^I am logged in as a client$/ do
  @vendor = create(:client, is_account_master: true, users_attributes: [attributes_for(:user)])
  @client = create(:client, account_id: @vendor.account_id, users_attributes: [attributes_for(:user)])
  #@user = create(:user, client_id: @client.id)
  @user = @client.users.first
  # @vendor_user = create(:user, client_id: @vendor.id)
  @vendor_user = @vendor.users.first
  login(@vendor.account.subdomain, @user.email, @user.password)
end

Given /^I have a client named "(.*?)"$/ do |client|
  @client = create(:client, name: client, account_id: @user.client.account_id, users_attributes: [attributes_for(:user)])
  # @client_user = create(:user, client_id: @client.id)
  @client_user = @client.users.first
end

Given /^they have a user named "(.*?)"$/ do |name|
  @specific_client_user = create(:user, client_id: @client.id, first_name: name)
end

Then /^I should be redirected to the account dashboard$/ do
  @blocked_urls.each do |url|
    visit url
    find('h4').should have_content('Open Estimates')
  end
end

When /^I click "(.*?)" from the apps homepage$/ do |link_text|
  visit site_url(:subdomain => false)
  click_link(link_text)
end

module LoginSteps
  def login(subdomain, name, password)
    visit log_in_url(:subdomain => subdomain)
    find("input[placeholder='Email Address']").set name
    find("input[placeholder='Password']").set password
    click_button('Log In')
  end
end

World(LoginSteps)
