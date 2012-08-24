When /^I go to the New Invoice Schedule page$/ do
  visit new_estimate_invoice_schedule_url(@estimate, :subdomain => @user.client.account.subdomain)
end

When /^I create only one Invoice Milestone$/ do
  find('input#invoice_schedule_invoice_milestones_attributes_0_estimate_percentage').set 100
  click_button('Save')
end

Given /^I have created an invoice schedule$/ do
  @invoice_schedule = build(:invoice_schedule, estimate_id: @estimate.id, id: 1)
  2.times do
  	invoice_milestone = create(:invoice_milestone, estimate_percentage: 50, invoice_schedule_id: @invoice_schedule.id)
  end
  @invoice_schedule.save
end

When /^I go to the Edit Invoice Schedule page$/ do
  visit edit_invoice_schedule_url(@invoice_schedule, :subdomain => @user.client.account.subdomain)
end

When /^I change milestone "(.*?)" to "(.*?)" percent$/ do |invoice_milestone_number, estimate_percentage|
    find("input#invoice_schedule_invoice_milestones_attributes_#{Integer(invoice_milestone_number)-1}_estimate_percentage").set estimate_percentage
end

When /^I save the changes$/ do
  click_button('Save')
end

When /^I go to any blocked invoice schedules section$/ do
  @estimate = create(:estimate, client_id: @client.id)
  @invoice_schedule = build(:invoice_schedule, estimate_id: @estimate.id, id: 1)
  2.times do
  	invoice_milestone = create(:invoice_milestone, estimate_percentage: 50, invoice_schedule_id: @invoice_schedule.id)
  end
  @invoice_schedule.save
  @blocked_urls = [
    new_estimate_invoice_schedule_url(@estimate, :subdomain => @vendor.account.subdomain),
    edit_invoice_schedule_url(@invoice_schedule, :subdomain => @vendor.account.subdomain)
  ]
end
