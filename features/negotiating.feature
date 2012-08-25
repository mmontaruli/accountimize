Feature: Negotiate estimates
	In order to agree on an estimate
	As a vendor or client
	I want to be able to negotiate and accept an estimate

	Scenario: De-selecting line items
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an estimate created for them for "Web Design" for "3000"
		When I go to the Edit Estimate page
		And I uncheck this line item
		And I save the changes
		Then I should see "Estimate was successfully updated."
		And I should see the line item total "0.00"

	Scenario: Negotiating a line item
		Given I am logged in as a client
		And I am customizing an estimate for "Web Design" for "3000"
		When I negotiate this by commenting "Should be cheaper" and countering "2500"
		Then I should see "2,500.00" as a negotiation in the Edit Estimate page

	Scenario: Accepting a negotiation
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an estimate created for them for "Web Design" for "3000"
		And they have counter-offered for "2500"
		When I accept this line item
		And I save the changes
		Then I should see "Estimate was successfully updated."
		And I should see this line item priced at "2,500.00"

	Scenario: Accepting an estimate
		Given I am logged in as a client
		And I am customizing an estimate
		And all line items on this estimate have been accepted
		When I click on the accept estimate button
		And I save the changes
		Then I should see "Estimate Accepted"

	Scenario: Accepting a new estimate
		Given I am logged in as a client
		And I am customizing an estimate
		And no line items have been accepted or negotiated
		When I click on the accept estimate button
		And I save the changes
		Then I should see "Estimate Accepted"