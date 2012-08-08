When /^I go to the New Invoice Schedule page$/ do
  visit "http://#{@user.client.account.subdomain}.example.com/estimates/#{@estimate.id}/invoice_schedules/new"
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
  visit "http://#{@user.client.account.subdomain}.example.com/invoice_schedules/#{@invoice_schedule.id}/edit"
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
    "http://#{@vendor.account.subdomain}.example.com/estimates/#{@estimate.id}/invoice_schedules/new",
    "http://#{@vendor.account.subdomain}.example.com/invoice_schedules/#{@invoice_schedule.id}/edit"
  ]
end
