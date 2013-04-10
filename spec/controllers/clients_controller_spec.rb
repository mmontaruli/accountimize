require 'spec_helper'

describe ClientsController do
	before(:each) do
		# @user = create(:user)
  		# @user.client.is_account_master = true
  		# @user.client.save
  		vendor = create(:client, is_account_master: true, users_attributes: [attributes_for(:user)])
  		@user = vendor.users.first
  		@request.host = "#{@user.client.account.subdomain}.test.host"
  		session[:user_id] = @user.id
  		@client = create(:client, account_id: @user.client.account_id, users_attributes: [attributes_for(:user)])
  		#@client_user = create(:user, client_id: @client.id)
  		@client_user = @client.users.first
	end
	describe "#index" do
		it "should be successful" do
			get :index
			response.should be_success
		end
		it "should not allow access to client" do
			session[:user_id] = @client_user.id
			get :index
			response.should redirect_to site_url
		end
	end
	describe "#new" do
		it "should be successful" do
			get :new
			response.should be_success
		end
		it "should not allow access to client" do
			session[:user_id] = @client_user.id
			get :new
			response.should redirect_to site_url
		end
	end
	describe "#create" do
		it "should create a client" do
			#post :create, "client" => {"name" => "testing", "account_id" => @user.client.account_id}
			#post :create, estimate_id: @estimate.id, invoice_schedule: attributes_for(:invoice_schedule, invoice_milestones_attributes: [attributes_for(:invoice_milestone)])
			post :create, "client" => {"name" => "testing", "account_id" => @user.client.account_id, users_attributes: [attributes_for(:user)]}
			assigns(:client).should_not be_nil
			assigns(:client).name.should eql("testing")
			assigns(:client).users.should_not be_nil
		end
	end
	describe "#edit" do
		it "should be successful" do
			get :edit, id: @client
			response.should be_success
		end
		it "should not allow access to client" do
			session[:user_id] = @client_user.id
			get :edit, id: @client
			response.should redirect_to site_url
		end
	end
	describe "#update" do
		it "should update client" do
			post :update, id: @client.to_param, name: "hello"
			response.should redirect_to client_url(@client)
		end
	end
	describe "#destroy" do
		it "should destroy client" do
			expect { post :destroy, id: @client.id }.to change(Client, :count).by(-1)
		end
	end
end