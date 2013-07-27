Given /^I have a new message "(.*?)"$/ do |subject|
  @message = create(:message, user_id: @user.id, subject: subject)
end

When /^I go to view my messages$/ do
  visit messages_url(subdomain: @user.client.account.subdomain)
end

Given /^this new message says "(.*?)"$/ do |body|
  @message.body = body
  @message.save
end

When /^I click on "(.*?)"$/ do |link_text|
  click_link(link_text)
end

When /^I click the delete button next to this message$/ do
  #find('a', :href => "#{message_path(@message)}", :text => 'Delete').click
  find('a', :text => 'Delete').click
end
