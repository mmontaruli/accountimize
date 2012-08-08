Given /^I have a new contact whose email is "(.*?)"$/ do |email_address|
  @email_address = email_address
end

When /^I go to the page to add a contact for this client$/ do
  visit "http://#{@user.client.account.subdomain}.example.com/users/new?client_id=#{@client.id}"
end

When /^I fill in and save this new contacts email and temporary password$/ do
    find('input#user_email').set @email_address
    find('input#user_password').set 'harry'
    find('input#user_password_confirmation').set 'harry'
    click_button('Create User')
end

When /^I go to any blocked user section$/ do
	@blocked_urls = [
		"http://#{@user.client.account.subdomain}.example.com/users/new?client_id=#{@client.id}"
	]
end
