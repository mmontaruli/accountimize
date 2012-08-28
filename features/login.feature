Feature: Logging in and out
	In order to access Accountimize
	As a user
	I want to log into and out of my account

	Scenario: Logging into an account
		Given I have an account
		And my name is "Fred Smith"
		When I log in
		Then I should see "Logged in"
		And I should see "Hello Fred"

	Scenario: Logging out of an account
		Given I have an account
		And I am logged in
		And I would like to log out
		When I click "Logout"
		Then I should see "Logged out!"

	Scenario: Changing settings
		Given I have an account
		And I am logged in
		When I click "Settings"
		Then I should see "Edit User"