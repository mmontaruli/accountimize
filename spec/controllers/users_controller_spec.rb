require 'spec_helper'

describe UsersController do
	before(:each) do
		@user = create(:user)
  		@user.client.is_account_master = true
  		@user.client.save
  		@request.host = "#{@user.client.account.subdomain}.test.host"
  		session[:user_id] = @user.id
  		@client = create(:client, account_id: @user.client.account_id)
  		@client_user = create(:user, client_id: @client.id)
	end
	describe "#new" do
		it "should be successful" do
			get :new, client_id: @client.id
			response.should be_success
		end
		it "should not allow access to client" do
			session[:user_id] = @client_user.id
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