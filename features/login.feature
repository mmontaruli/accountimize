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

	Scenario: Logging in through main domain
		Given I have an account
		And my name is "Fred Smith"
		When I click "Login" from the apps homepage
		And I enter my email address in the subdomain search field
		Then I should see "Log in"
		And I should be able to log in with my credentials

	Scenario: Attempting to log in through main domain with no account
		Given I do not have an account
		And my email address is "notavalid@email.com"
		When I click "Login" from the apps homepage
		And I enter my invalid email address in the subdomain search field
		Then I should see "We cannot locate your email address"

	Scenario: Client has account with two different vendors
		Given there are two vendors, "Acme" and "Smith"
		And my email address is "fred@google.com"
		And I am a client of "Acme"
		And I later become a client of "Smith"
		When I log in to the "Smith" account
		Then I should see "Logged in"
