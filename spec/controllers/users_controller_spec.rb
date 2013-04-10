require 'spec_helper'

describe UsersController do
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
  		@another_client = create(:client, account_id: @user.client.account_id, users_attributes: [attributes_for(:user)])
  		#@another_client_user = create(:user, client_id: @another_client.id)
  		@another_client_user = @another_client.users.first
	end
	describe "#new" do
		it "should be successful" do
			get :new, client_id: @client.id
			response.should be_success
		end
		it "should not allow access to a different client" do
			#session[:user_id] = @client_user.id
			session[:user_id] = @another_client_user.id
			get :new, client_id: @client.id
			response.should redirect_to site_url
		end
	end
	describe "#edit" do
		it "should be successful" do
			get :edit, id: @user.id
			response.should be_success
		end
		it "should allow client to access to client user" do
			session[:user_id] = @client_user.id
			get :edit, id: @client_user.id
			response.should be_success
		end
		it "should not allow client to access other users" do
			session[:user_id] = @client_user.id
			get :edit, id: @user.id
			response.should redirect_to site_url
		end
	end
	describe "#create" do
		it "should create a user" do
			post :create, "user" => {"email"=>"lorem@ipsum.com", "password"=>"lorem", "password_confirmation"=>"lorem", "client_id" => @client.id, "first_name" => "Fred", "last_name" => "Smith"}
			assigns(:user).should_not be_nil
      		assigns(:user).email.should == "lorem@ipsum.com"
		end
	end
	describe "#update" do
		it "should update user" do
			post :update, id: @client_user.to_param, first_name: "Fredrick"
			response.should redirect_to client_url(@client)
		end
	end
end