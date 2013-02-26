When /^I log in$/ do
  login(@user.client.account.subdomain, @user.email, @user.password)
end

Given /^I am logged in$/ do
  login(@user.client.account.subdomain, @user.email, @user.password)
end

Given /^I would like to log out$/ do
end

Given /^I am a vendor$/ do
  if @user
    @user.client.is_account_master = true
    @user.client.save
  end
end

Given /^there are two vendors, "(.*?)" and "(.*?)"$/ do |vendor_name_1, vendor_name_2|
  create(:account, name: vendor_name_1)
  create(:account, name: vendor_name_2)
end

Given /^I am a client of "(.*?)"$/ do |vendor_name|
  vendor = Account.find_by_name(vendor_name)
  client_1 = create(:client, account_id: vendor.id)
  create(:user, email: @new_email_address, client_id: client_1.id)
end

Given /^I later become a client of "(.*?)"$/ do |vendor_name|
  vendor = Account.find_by_name(vendor_name)
  client_2 = create(:client, account_id: vendor.id)
  @user_2 = create(:user, email: @new_email_address, client_id: client_2.id)
end

When /^I log in to the "(.*?)" account$/ do |vendor_name|
  vendor = Account.find_by_name(vendor_name)
  login(vendor.subdomain, @user_2.email, @user_2.password)
end
