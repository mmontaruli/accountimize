Feature: Manage accounts
	In order to use Accountimize
	As a vendor
	I want to create and manage an account

	Scenario: Creating a new account
		Given I do not have an account
		And my email address is "matt@acme.com"
		And my company name is "Acme"
		And my name is "Fred Smith"
		When I sign up for a new account
		Then I should see "Account was successfully created."

	Scenario: Entering a insecure password
		Given I do not have an account
		And my email address is "matt@acme.com"
		And my company name is "Acme"
		And my name is "Fred Smith"
		When I sign up for a new account and enter the password "fred"
		Then I should see "password should be between 8 and 40 characeters long and should have at least one number and upper case letter"

	Scenario: Entering a non-email address
		Given I do not have an account
		And I enter my email address as "matt"
		And my company name is "Acme"
		And my name is "Fred Smith"
		When I sign up for a new account
		Then I should see "email is invalid"
