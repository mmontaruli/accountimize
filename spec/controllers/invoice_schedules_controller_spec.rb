require 'spec_helper'

describe InvoiceSchedulesController do
	before(:each) do
		@user = create(:user)
  		@user.client.is_account_master = true
  		@user.client.save
  		@request.host = "#{@user.client.account.subdomain}.test.host"
  		session[:user_id] = @user.id
  		@client = create(:client, account_id: @user.client.account_id)
  		@estimate = create(:estimate, client_id: @client.id)
  		@invoice_schedule = build(:invoice_schedule, estimate_id: @estimate.id, id: 1)
  		2.times do
  			invoice_milestone = create(:invoice_milestone, estimate_percentage: 50, invoice_schedule_id: @invoice_schedule.id)
  		end
  		@invoice_schedule.save
  		@client_user = create(:user, client_id: @client.id)
	end
	describe "#new" do
		it "should be successful" do
			get :new, estimate_id: @estimate
			response.should be_successful
		end
		it "should not allow access to client" do
			session[:user_id] = @client_user.id
			get :new, estimate_id: @estimate
			response.should redirect_to site_url
		end
	end
	describe "#create" do
		it "should create an invoice schedule" do
	      	post :create, :estimate_id => @estimate,
            	:invoice_schedule => {
              		:invoice_milestones_attributes => {
                		"0" =>{:estimate_percentage => 100, :description => "test"}
              		}
            	}
			assigns(:invoice_schedule).should_not be_nil
		end
	end
	describe "#edit" do
		it "should be successful" do
			get :edit, id: @invoice_schedule
			response.should be_successful
		end
		it "should not allow access to client" do
			session[:user_id] = @client_user.id
			get :edit, id: @invoice_schedule
			response.should redirect_to site_url
		end
	end
	describe "#update" do
		it "should update invoice schedule" do
			@new_estimate = create(:estimate, client_id: @client.id)
			post :update, id: @invoice_schedule.to_param, estimate_id: @new_estimate.id
			response.should redirect_to invoice_schedule_url(@invoice_schedule)
		end
	end
end