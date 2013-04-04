require 'spec_helper'
require 'ruby-debug'

describe EstimatesController do
	before(:each) do
		@user = create(:user)
  		@user.client.is_account_master = true
  		@user.client.save
  		@user.received_estimate = true
  		@user.save
  		@request.host = "#{@user.client.account.subdomain}.test.host"
  		session[:user_id] = @user.id
  		@client = create(:client, account_id: @user.client.account_id)
  		@client_user = create(:user, client_id: @client.id)
  		@estimate = create(:estimate, client_id: @client.id, send_to_contact: @client_user.id)
	end
	describe "#index" do
		it "should be a success" do
			get :index
			response.should be_success
		end
	end
	describe "#new" do
		it "should be a success" do
			get :new
			response.should be_success
		end
		it "should not allow access to client" do
			session[:user_id] = @client_user.id
			get :new
			response.should redirect_to site_url
		end
		it "should not allow me to view client data from another account" do
			other_account = create(:account)
			other_client = create(:client, account_id: other_account.id)
			get :new, client_id: other_client.id
			response.should redirect_to site_url
		end
		it "should build three unselected line items" do
			get :new
			assigns(:estimate).line_items.should be_present
			assigns(:estimate).line_items.length.should eql(3)
			assigns(:estimate).line_items[0].is_enabled.should be_false
		end
	end
	describe "#create" do
		it "should create an estimate" do
			expect {post :create, estimate: attributes_for(:estimate, client_id: @user.client_id, send_to_contact: @user.id)}.to change(Estimate, :count).by(1)
		end
		it "should send a new estimate notification to client" do
			post :create, estimate: attributes_for(:estimate, client_id: @user.client_id, send_to_contact: @user.id)
			Message.last.subject.should include("New Estimate #")
		end
		it "should send a new password email to new clients" do
			user = create(:user, received_estimate: false, client_id: @user.client_id)
			post :create, estimate: attributes_for(:estimate, client_id: user.client_id, send_to_contact: user.id)
			ActionMailer::Base.deliveries.last.subject.should include("#{user.client.account.name} just sent you an estimate via Accountimize")
		end
	end
	describe "#edit" do
		it "should be successful" do
			get :edit, :id => @estimate
			response.should be_success
		end
		it "should not be marked as reviewed if client is viewing for first time" do
			session[:user_id] = @client_user.id
			get :edit, :id => @estimate
			@estimate.already_reviewed.should be_false
		end
	end
	describe "#update" do
		it "should update estimate" do
			post :update, id: @estimate.to_param, number: 200
			response.should redirect_to estimate_url(@estimate)
		end
		it "should send notification if a new negotiation is made" do
			post :update, :id => @estimate, :estimate => {
				:line_items_attributes => [
					attributes_for(:line_item,
						:negotiate_lines_attributes => [
							attributes_for(:negotiate_line, user_negotiating: @user.email)
						]
					)
				], :is_accepted => false
			}

            Message.last.subject.should include("New negotiation on estimate #")
            Message.last.user_id.should == @client_user.id
		end
		it "should mark estimate as already_reviewed once client saves for the first time" do
			session[:user_id] = @client_user.id
			post :update, id: @estimate.to_param

			assigns(:estimate).already_reviewed.should be_true
		end
	end
	describe "#destroy" do
		it "should destroy estimate" do
			expect { post :destroy, id: @estimate.id }.to change(Estimate, :count).by(-1)
		end
	end
end
