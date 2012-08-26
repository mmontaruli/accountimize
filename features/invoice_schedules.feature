Feature: Create and Edit Invoice Schedules
	In order to generate invoices from estimates
	As a vendor
	I want to create and edit invoice schedules

	Scenario: Creating an invoice schedule
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have created an estimate for this client
		When I go to the New Invoice Schedule page
		And I create only one Invoice Milestone
		Then I should see "Invoice schedule was successfully created."

	Scenario: Editing an invoice schedule
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have created an estimate for this client
		And I have created an invoice schedule
		When I go to the Edit Invoice Schedule page
		And I change milestone "1" to "75" percent
		And I change milestone "2" to "25" percent
		And I save the changes
		Then I should see "Invoice schedule was successfully updated."

	Scenario: Blocked access for client user
		Given I am logged in as a client
		When I go to any blocked invoice schedules section
		Then I should be redirected to the account dashboard

	Scenario: Generate invoice
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an estimate created for them for "Web Design" for "3000"
		And I have created an invoice schedule
		When I go to the invoice schedule page
		And I click "Generate Invoice" from the first milestone
		Then I should see "Invoice was successfully generated."
		And I should see "$1,500"



