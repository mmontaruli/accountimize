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

	@javascript
	Scenario: Creating an estimate
		Given I am logged in as a vendor
		And I have a client named "Google"
		And they have a user named "Mike"
		And The client would like a quote for "Web Design"
		And My services cost "3000"
		When I go to the New Estimate page
		And I fill in and submit this estimate information
		Then I should see "Estimate was successfully created."
		# And client should receive a new estimate notification
		# this is tested elsewhere anyway...is it even needed here?

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

	@javascript
	Scenario: Drag and drop line items for vendor user
		Given I am logged in as a vendor
		And I have a client named "Google"
		And I have an estimate created for them for "Web Design" for "3000"
		And it has another line item for "Marketing" for "4000"
		When I go to the Edit Estimate page
		And I drag the "Marketing" line item to the top of the estimate
		And I save the changes
  		Then the line item "Marketing" should be at the top of the estimate

  	@javascript
  	Scenario: Deselected line items listed in deselected table
  		Given I am logged in as a client
  		And the vendor has sent me an estimate
  		And the estimate has a line item for "Web Design" for "3000"
  		And the estimate has a line item for "Marketing" for "4000"
  		And I am reviewing the estimate for the first time
  		When I click on the "Marketing" line item to select it
		And I click "Next" to go to the second step
		Then I should see "Web Design" in the deselected table
		And the estimate should total "$4,000.00"

	@javascript
  	Scenario: Selected line items listed in selected table
  		Given I am logged in as a client
  		And the vendor has sent me an estimate
  		And the estimate has a line item for "Web Design" for "3000"
  		And the estimate has a line item for "Marketing" for "4000"
  		And I am reviewing the estimate for the first time
  		When I click on the "Marketing" line item to select it
		And I click "Next" to go to the second step
		Then I should see "Marketing" in the selected table
		And the estimate should total "$4,000.00"

	@javascript
	Scenario: Dragging and dropping line items to deselect table deselects it
		Given I am logged in as a client
		And the vendor has sent me an estimate
		And the estimate has a selected line item for "Web Design" for "3000"
		And the estimate has a selected line item for "Marketing" for "4000"
		And I am reviewing an estimate for the second time
		When I drag the "Marketing" line item to the deselected area
		And I save the changes
		Then the "Marketing" line item should appear deselected on the estimate view page

	@javascript
	Scenario: Dragging and dropping line items to select table selects it
		Given I am logged in as a client
		And the vendor has sent me an estimate
		And the estimate has a deselected line item for "Web Design" for "3000"
		And the estimate has a deselected line item for "Marketing" for "4000"
		And I am reviewing an estimate for the second time
		When I drag the "Marketing" line item to the selected area
		And I save the changes
		Then the "Marketing" line item should appear selected on the estimate view page

