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

Given /^I have an account$/ do
  @user = create(:user)
end
