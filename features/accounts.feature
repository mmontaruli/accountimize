Feature: Manage accounts
	In order to use Accountimize
	As a vendor
	I want to create and manage an account

	Scenario: Creating a new account
		Given I do not have an account
		And my email address is "matt@acme.com"
		And my company name is "Acme"
		When I sign up for a new account
		Then I should see "Account was successfully created."
