Given /^I have created estimate number "(.*?)" for them$/ do |estimate_number|
  @estimate = create(:estimate, number: estimate_number, client_id: @client.id)
end

When /^I go to the list of estimates$/ do
  visit estimates_url(:subdomain => @user.client.account.subdomain)
end

Given /^The client would like a quote for "(.*?)"$/ do |service_name|
  @service_name = service_name
end

Given /^My services cost "(.*?)"$/ do |service_cost|
  @service_cost = service_cost
end

When /^I go to the New Estimate page$/ do
  visit new_estimate_url(:subdomain => @user.client.account.subdomain)
end

When /^I fill in and submit this estimate information$/ do
  select("Google", :from => "estimate_client_id")
  find('input#estimate_line_items_attributes_0_name').set @service_name
  find('input#estimate_line_items_attributes_0_quantity').set 1
  find('input#estimate_line_items_attributes_0_unit_price').set @service_cost
  click_button('Save')
end

Then /^I should see "(.*?)" line items$/ do |num|
  matching = all('table.line_items tr.line_item')
  matched = matching.size
  matched.should == Integer(num)
end

Given /^I have an estimate created for them for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  @estimate = create(:estimate, client_id: @client.id)
  line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost)
end

Given /^it has another line item for "(.*?)" for "(.*?)"$/ do |service_name, service_cost|
  line_item = create(:line_item, estimate_id: @estimate.id, name: service_name, unit_price: service_cost)
end

When /^I go to the Edit Estimate page$/ do
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
end

When /^I change the price to "(.*?)" and submit$/ do |new_price|
  find('input#estimate_line_items_attributes_0_unit_price').set new_price
  click_button('Save')
end

Given /^I have an estimate numbered "(.*?)"$/ do |estimate_number|
  @client = create(:client, account_id: @user.client.account_id)
  @estimate = create(:estimate, number: estimate_number, client_id: @client.id)
end

When /^I click the delete button next to this estimate$/ do
  find('a', :href => "#{estimate_path(@estimate)}", :text => 'Delete').click
end

When /^I go to any blocked estimate section$/ do
  @blocked_urls = [
    new_estimate_url(:subdomain => @vendor.account.subdomain)
  ]
end

Given /^I have created an estimate for this client$/ do
  @estimate = create(:estimate, client_id: @client.id)
  line_item = create(:line_item, estimate_id: @estimate.id)
end

Then /^client should receive a new estimate notification$/ do
  visit log_out_url(subdomain: @user.client.account.subdomain)
  login(@client.account.subdomain, @client_user.email, @client_user.password)
  visit messages_url(subdomain: @client.account.subdomain)
  page.should have_content("New Estimate #")
end

When /^I drag the "(.*?)" line item to the top of the estimate$/ do |line_item_name|
  drop_place = page.find(:css, 'table.second_step tbody tr:first')
  line_item = @estimate.line_items.find_by_name(line_item_name)
  page.find("table.second_step tr.line-id-#{line_item.id}").drag_to(drop_place)

  #post = Post.find_by_title(post_title)
  #distance = distance.to_i * -1 if direction == 'up'
  # distance = -1
  # page.execute_script %{
  #   $.getScript("http://your.bucket.s3.amazonaws.com/jquery.simulate.drag-sortable.js", function() {
  #     $("table.second_step tr.line-id-#{line_item.id}").simulateDragSortable({ move: #{distance.to_i}});
  #   });
  # }
end


# When /^I drag book "([^"]*)" to the top$/ do |book_title|
#   drop_place = page.find(:css, 'ul.sortable-books li:first')
#   page.find(:xpath, "//a[@href='##{book_title.parameterize}']").drag_to(drop_place)
# end

Then /^the line item "(.*?)" should be at the top of the estimate$/ do |line_item_name|
  #line_item = @estimate.line_items.find_by_name(line_item_name)
  visit edit_estimate_url(@estimate, :subdomain => @user.client.account.subdomain)
  #save_and_open_page
  #page.find("table.second_step tbody tr:first td.line_name input").should have_content(line_item_name)
  page.find("table.second_step tbody tr:first td.line_name input").value.should eq line_item_name
end

