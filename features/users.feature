Feature: Adding and editing users
	In order to quote and invoice customers
	As a vendor
	I want to create and edit users who can view these estimates and invoices

	Scenario: Creating a new user
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have a new contact whose email is "fred@google.com"
		And his name is "Fred Smith"
		When I go to the page to add a contact for this client
		And I fill in and save this new contacts name, email and temporary password
		Then I should see "Signed up!"
		And I should see "Fred Smith"

	Scenario: Blocked access for client user
		Given I am logged in as a client
		When I go to any blocked user section
		Then I should be redirected to the account dashboard
