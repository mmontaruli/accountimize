Given /^I do not have an account$/ do
end

Given /^my email address is "(.*?)"$/ do |email_address|
  @new_email_address = email_address
end

Given /^I enter my email address as "(.*?)"$/ do |email_address|
  @new_email_address = email_address
end

Given /^my company name is "(.*?)"$/ do |company_name|
  @new_company_name = company_name
end

When /^I sign up for a new account$/ do
  visit('/sign_up')
  fill_in('account_name', :with => @new_company_name)
  find("input[placeholder='Email Address']").set @new_email_address
  find("input[placeholder='Password']").set "Ipsum1234"
  find("input[placeholder='Confirm Password']").set "Ipsum1234"
  click_button('Save')
end

When /^I sign up for a new account and enter the password "(.*?)"$/ do |password|
  visit('/sign_up')
  fill_in('account_name', :with => @new_company_name)
  find("input[placeholder='Email Address']").set @new_email_address
  find("input[placeholder='Password']").set password
  find("input[placeholder='Confirm Password']").set password
  click_button('Save')
end

Given /^I have an account$/ do
  @user = create(:user)
  if @first_name
    @user.first_name = @first_name
    @user.save
  end
end

Given /^my name is "(.*?)"$/ do |full_name|
  @first_name = full_name.split(' ')[0]
  @last_name = full_name.split(' ')[1]
end

When /^I enter my email address in the subdomain search field$/ do
  email_address = @new_email_address || @user.email
  #find("input[name='email']").set @user.email
  find("input[name='email']").set email_address
  click_button('Search')
end

Then /^I should be able to log in with my credentials$/ do
  find("input[placeholder='Email Address']").set @user.email
  find("input[placeholder='Password']").set @user.password
  click_button('Log In')
  page.should have_content("Logged in")
end

When /^I enter my invalid email address in the subdomain search field$/ do
  find("input[name='email']").set @new_email_address
  click_button('Search')
end

Given /^an account already exists with "(.*?)" as a user$/ do |email_address|
  other_vendor_user = create(:user, email: email_address)
  other_vendor_user.client.is_account_master = true
  other_vendor_user.client.save
end
