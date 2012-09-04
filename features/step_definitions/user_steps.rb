Given /^I have a new contact whose email is "(.*?)"$/ do |email_address|
  @email_address = email_address
end

When /^I go to the page to add a contact for this client$/ do
  visit new_user_url(:client_id => @client.id, :subdomain => @user.client.account.subdomain)
end

When /^I fill in and save this new contacts name, email and temporary password$/ do
	find('input#user_email').set @email_address
  find('input#user_password').set 'Harry123'
  find('input#user_password_confirmation').set 'Harry123'
  find('input#user_first_name').set @first_name
  find('input#user_last_name').set @last_name
  click_button('Save')
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

Given /^I have a contact named "(.*?)"$/ do |full_name|
  first_name = full_name.split(' ')[0]
  last_name = full_name.split(' ')[1]

  @contact = create(:user, client_id: @client.id, first_name: first_name, last_name: last_name)
end

When /^I go to the user edit page$/ do
  visit edit_user_url(@contact, :subdomain => @user.client.account.subdomain)
end

When /^I change his first name to "(.*?)" and save$/ do |new_first_name|
  find('input#user_first_name').set new_first_name
  click_button('Save')
end

When /^I go to edit my user info$/ do
  visit edit_user_url(@user, :subdomain => @user.client.account.subdomain)
end

Given /^I am on the log in page$/ do
  visit log_in_url(:subdomain => @user.client.account.subdomain)
end

When /^I enter my email address$/ do
  find('input#email').set @user.email
  click_button('Reset Password')
end


Then /^when I change my password I should see "(.*?)"$/ do |confirmation_message|
  @new_password = "Freddie123"
  message = ActionMailer::Base.deliveries.last.body.to_s
  start_url = message.index("http")
  end_url = message.index("edit")+3
  mailer_password_reset_url = message[start_url..end_url]
  visit mailer_password_reset_url
  find("input[placeholder='New password']").set @new_password
  find("input[placeholder='Confirm new password']").set @new_password
  click_button('Update Password')
  page.should have_content(confirmation_message)
end

Then /^I should be able to log in with my new password$/ do
  login(@user.client.account.subdomain, @user.email, @new_password)
  page.should have_content("Logged in!")
end

