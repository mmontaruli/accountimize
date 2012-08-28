Given /^I have a new contact whose email is "(.*?)"$/ do |email_address|
  @email_address = email_address
end

When /^I go to the page to add a contact for this client$/ do
  visit new_user_url(:client_id => @client.id, :subdomain => @user.client.account.subdomain)
end

# When /^I fill in and save this new contacts email and temporary password$/ do
#     find('input#user_email').set @email_address
#     find('input#user_password').set 'harry'
#     find('input#user_password_confirmation').set 'harry'
#     click_button('Create User')
# end

When /^I fill in and save this new contacts name, email and temporary password$/ do
	find('input#user_email').set @email_address
    find('input#user_password').set 'harry'
    find('input#user_password_confirmation').set 'harry'
    find('input#user_first_name').set @first_name
    find('input#user_last_name').set @last_name
    click_button('Create User')
end

When /^I go to any blocked user section$/ do
	@blocked_urls = [
		new_user_url(:client_id => @client.id, :subdomain => @user.client.account.subdomain)
	]
end

Given /^his name is "(.*?)"$/ do |full_name|
  @first_name = full_name.split(' ')[0]
  @last_name = full_name.split(' ')[1]
end
