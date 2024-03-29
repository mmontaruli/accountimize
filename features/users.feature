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
		#And I fill in and save this new contacts name, email and temporary password
		And I fill in and save this new contacts name and email
		Then I should see "Signed up!"
		And I should see "Fred Smith"

	Scenario: Editing a user
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have a contact named "Fred Smith"
		When I go to the user edit page
		And I change his first name to "Fredrick" and save
		Then I should see "User was successfully updated."
		And I should see "Fredrick Smith"

	Scenario: Blocked access for client user
		Given I am logged in as a client
		When I go to any blocked user section
		Then I should be redirected to the account dashboard

	Scenario: Client can only edit their own user info
		Given I am logged in as a client
		When I go to edit my user info
		Then I should see "Edit User"

	Scenario: Forgot password
		Given I have an account
		And I am a vendor
		And I am on the log in page
		When I click "Forgot password"
		And I enter my email address
		Then I should see "Email sent with password reset instructions"
		And when I change my password I should see "Password has been reset!"
		And I should be able to log in with my new password

	Scenario: Adding a client whose already someone elses client
		Given I am logged in as a vendor
		And another account exists that has "Google" as their client
		And their client has a user "fred@google.com"
		And I have "Google" as a client as well
		When I add "fred@google.com" as a contact for this client
		Then I should see "Signed up!"

	@email
	Scenario: Receiving password notification after receiving first estimate
		Given I am a client
		And I have never received any estimates before
		When my first estimate is sent to me
		Then I should receive an email with my password
		And I should be able to log in with my new password
