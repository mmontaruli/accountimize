Feature: Manage messages
	In order to keep up with who I'm negotiating with
	As a vendor or client
	I want to receive messages

	Scenario: View message list
		Given I am logged in as a vendor
		And I have a new message "New negotiation"
		When I go to view my messages
		Then I should see "New negotiation"

	Scenario: View message
		Given I am logged in as a vendor
		And I have a new message "New negotiation"
		And this new message says "You have a new negotiation"
		When I go to view my messages
		And I click on "New negotiation"
		Then I should see "You have a new negotiation"

	Scenario: Destroy message
		Given I am logged in as a vendor
		And I have a new message "New negotiation"
		When I go to view my messages
		And I click the delete button next to this message
		Then I should not see "New negotiation"