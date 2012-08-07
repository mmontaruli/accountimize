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