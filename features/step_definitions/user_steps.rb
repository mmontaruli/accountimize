require 'ruby-debug'

Given /^I have a new contact whose email is "(.*?)"$/ do |email_address|
  @email_address = email_address
end

When /^I go to the page to add a contact for this client$/ do
  visit new_user_url(:client_id => @client.id, :subdomain => @user.client.account.subdomain)
end

# When /^I fill in and save this new contacts name, email and temporary password$/ do
# 	find('input#user_email').set @email_address
#   find('input#user_password').set 'Harry123'
#   find('input#user_password_confirmation').set 'Harry123'
#   find('input#user_first_name').set @first_name
#   find('input#user_last_name').set @last_name
#   click_button('Save')
# end

When /^I fill in and save this new contacts name and email$/ do
  find('input#user_email').set @email_address
  # find('input#user_password').set 'Harry123'
  # find('input#user_password_confirmation').set 'Harry123'
  find('input#user_first_name').set @first_name
  find('input#user_last_name').set @last_name
  click_button('Save')
end

When /^I go to any blocked user section$/ do
	@another_client = create(:client, account_id: @vendor.account_id)
  @blocked_urls = [
		new_user_url(:client_id => @another_client.id, :subdomain => @user.client.account.subdomain)
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

Given /^another account exists that has "(.*?)" as their client$/ do |client_name|
  other_account = create(:account)
  @existing_client = create(:client, name: client_name, account_id: other_account.id)
end

Given /^their client has a user "(.*?)"$/ do |email_address|
  create(:user, email: email_address, client_id: @existing_client.id)
end

Given /^I have "(.*?)" as a client as well$/ do |client_name|
  @my_client = create(:client, name: client_name, account_id: @user.client.account.id)
end

When /^I add "(.*?)" as a contact for this client$/ do |email_address|
  #create(:user, email: email_address, client_id: @my_client.id)
  visit client_url(@my_client, subdomain: @user.client.account.subdomain)
  click_link("Add Contact")
  find("input[placeholder='Email Address']").set email_address
  # find("input[placeholder='Password']").set "Fred1234"
  # find("input[placeholder='Confirm Password']").set "Fred1234"
  click_button("Save")
end

Given /^I am a client$/ do
  @client_user = create(:user)
end

Given /^I have never received any estimates before$/ do
  @client_user.received_estimate = false
  @client_user.save
end

When /^my first estimate is sent to me$/ do
  # @estimate = create(:estimate, client_id: @client_user.client.id, send_to_contact: @client_user.id)
  @vendor = create(:client, account_id: @client_user.client.account.id, is_account_master: true)
  @vendor_user = create(:user, client_id: @vendor.id)
  login(@vendor_user.client.account.subdomain, @vendor_user.email, @vendor_user.password)
  # post '/estimates', estimate: attributes_for(:estimate, client_id: @client_user.client_id, send_to_contact: @client_user.id)
  #visit new_estimate_url(:subdomain => @vendor_user.client.account.subdomain)
  visit client_url(@client_user.client, :subdomain => @vendor_user.client.account.subdomain)
  click_link('Create New Estimate')
  #select(@client_user.client.name, :from => "estimate_client_id")
  select(@client_user.email, :from => "estimate_send_to_contact")
  find('input#estimate_line_items_attributes_0_name').set "Web Design"
  find('input#estimate_line_items_attributes_0_quantity').set 1
  find('input#estimate_line_items_attributes_0_unit_price').set 3000
  click_button('Save')
  click_link('Logout')
end

Then /^I should receive an email with my password$/ do
  message = ActionMailer::Base.deliveries.last
  message.to[0].should == @client_user.email
  message_body = message.body.to_s
  start_password_string = message_body.index("Password:")
  end_password_string = message_body.index("Enjoy!")
  password_string = message_body[start_password_string..end_password_string]
  password_string = password_string[10..29]
  @new_password = password_string
  @user = User.find(@client_user.id)
end
