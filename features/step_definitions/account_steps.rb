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
  find("input[placeholder='First Name']").set @first_name
  find("input[placeholder='Last Name']").set @last_name
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
