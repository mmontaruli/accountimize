Feature: Manage estimates
	In order to quote clients
	As a vendor
	I want to create and edit estimates

	Scenario: Estimate list
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have created estimate number "1002" for them
		When I go to the list of estimates
		Then I should see "1002"

	Scenario: Creating an estimate
		Given I am logged in as a vendor
		And I have a client named "Google"
		And The client would like a quote for "Web Design"
		And My services cost "3000"
		When I go to the New Estimate page
		And I fill in and submit this information
		Then I should see "Estimate was successfully created."

	Scenario: New estimate should start with three line items
		Given I am logged in as a vendor
		When I go to the New Estimate page
		Then I should see "3" line items

	Scenario: Editing an estimate
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an estimate created for them for "Web Design" for "3000"
		When I go to the Edit Estimate page
		And I change the price to "4000" and submit
		Then I should see "Estimate was successfully updated."
		And I should see "4,000.00"

	Scenario: Deleting an estimate
		Given I am logged in as a vendor
		And I have an estimate numbered "1003"
		When I go to the list of estimates
		And I click the delete button next to this estimate
		Then I should not see "1003"

	Scenario: Blocked access for client user
		Given I am logged in as a client
		When I go to any blocked estimate section
		Then I should be redirected to the account dashboard
