Feature: Manage clients
	In order to quote and bill clients
	As a vendor
	I want to create, edit and view client information

	Scenario: Client list
		Given I am logged in as a vendor
		And I have clients "Google" and "Facebook"
		When I go to the list of clients
		Then I should see "Google"
		And I should see "Facebook"

	Scenario: Creating a client
		Given I am logged in as a vendor
		And I would like to create a client "Twitter"
		And they have a contact "jim@twitter.com"
		When I go to the New Client page
		And I fill in and submit my new clients information
		Then I should see "Client was successfully created."

	Scenario: Editing a client
		Given I am logged in as a vendor
		And I have a client named "Google"
		When I go to the edit page for this client
		And I change the client name to "Facebook"
		Then I should see "Client was successfully updated."
		And I should see "Facebook"

	Scenario: Deleting a client
		Given I am logged in as a vendor
		And I have a client named "Google"
		When I go to the list of clients
		And I click the delete button next to this client
		Then I should not see "Google"

	Scenario: Blocked access for client user
		Given I am logged in as a client
		When I go to any client section
		Then I should be redirected to the account dashboard
