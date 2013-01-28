Feature: Negotiate estimates
	In order to agree on an estimate
	As a vendor or client
	I want to be able to negotiate and accept an estimate

	@javascript
	Scenario: De-selecting line items
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an estimate created for them for "Web Design" for "3000"
		And "Web Design" line item is selected
		When I drag the "Web Design" line item to the deselected area
		And I save the changes
		Then the "Web Design" line item should appear deselected on the estimate view page
		And I should see the line item total "0.00"

	@javascript
	Scenario: New (non-selected) line item still totals
		Given I am logged in as a vendor
		And I have a client named "Google"
		And The client would like a quote for "Web Design"
		And My services cost "3000"
		When I go to the New Estimate page
		And I fill in this estimate information
		Then I should see "3,000.00" as the line total
		And I should see "$3,000.00" as the estimate total

	@javascript
	Scenario: Editing (non-selected) line item doesn't total
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an estimate created for them for "Web Design" for "3000"
		When I go to the Edit Estimate page
		And I change this line item price to "3500"
		And I drag the "Web Design" line item to the deselected area
		Then I should see "0.00" as the line total
		And I should see "$0.00" as the estimate total

	@javascript
	Scenario: Selecting a line item in a new estimate
		Given I am logged in as a client
		And I am reviewing an estimate for "Web Design" for "3000" for the first time
		When I click on the line item to select it
		And I click "Next" to go to the second step
		And I have no negotiations to make
		And I click the "Save" button
		Then I should see "3,000" as the line total
		And I should see "$3,000.00" as the estimate total

	@javascript
	Scenario: Negotiating a line item on a new estimate
		Given I am logged in as a client
		And I am reviewing an estimate for "Web Design" for "3000" for the first time
		When I click on the line item to select it
		And I click "Next" to go to the second step
		And I negotiate this by commenting "Should be cheaper" and countering "2500"
		Then I should see "2,500.00" as a negotiation in the Edit Estimate page
		And vendor should receive a new negotiation notification

	@javascript
	Scenario: Negotiating a line item on an existing estimate
		Given I am logged in as a client
		And I am reviewing a previously reviewed estimate for "Web Design" for "3000"
		When I negotiate this by commenting "Should be cheaper" and countering "2500"
		Then I should see "2,500.00" as a negotiation in the Edit Estimate page
		And vendor should receive a new negotiation notification

	Scenario: Accepting a negotiation
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an estimate created for them for "Web Design" for "3000"
		And they have counter-offered for "2500"
		When I accept this line item
		And I confirm these changes and save
		Then I should see "Estimate was successfully updated."
		And I should see this line item priced at "2,500.00"

	Scenario: Accepting an estimate
		Given I am logged in as a client
		And I am customizing an estimate
		And all line items on this estimate have been accepted
		When I click on the accept estimate button
		And I confirm these changes and save
		Then I should see "Estimate Accepted"

	Scenario: Accepting a new estimate
		Given I am logged in as a client
		And I am customizing an estimate
		And no line items have been accepted or negotiated
		When I click on the accept estimate button
		And I confirm these changes and save
		Then I should see "Estimate Accepted"