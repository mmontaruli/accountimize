Feature: Manage invoices
	In order to invoice clients
	As a vendor
	I want to create and edit invoices

	Scenario: Invoice list
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have created invoice number "3002" for them
		When I go to the list of invoices
		Then I should see "3002"

	Scenario: Creating an Invoice
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I need to invoice this client for "Web Design"
		And My services cost "3000"
		When I go to the New Invoice page
		And I fill in and submit this invoicing information
		Then I should see "Invoice was successfully created."

	Scenario: New invoice should start with three line items
		Given I am logged in as a vendor
		When I go to the New Invoice page
		Then I should see "3" line items

	Scenario: Editing an invoice
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an invoice created for them for "Web Design" for "3000"
		When I go to the Edit Invoice page
		And I change the invoice line price to "4000" and submit
		Then I should see "Invoice was successfully updated."
		And I should see "4,000.00"

	Scenario: Deleting an invoice
		Given I am logged in as a vendor
		And I have an invoice numbered "3003"
		When I go to the list of invoices
		And I click the delete button next to this invoice
		Then I should not see "3003"

	Scenario: Blocked access for client user
		Given I am logged in as a client
		When I go to any blocked invoice section
		Then I should be redirected to the account dashboard
