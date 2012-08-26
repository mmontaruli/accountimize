require 'spec_helper'

describe ClientsController do
	before(:each) do
		@user = create(:user)
  		@user.client.is_account_master = true
  		@user.client.save
  		@request.host = "#{@user.client.account.subdomain}.test.host"
  		session[:user_id] = @user.id
  		@client = create(:client, account_id: @user.client.account_id)
  		@client_user = create(:user, client_id: @client.id)
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
			post :create, "client" => {"name" => "testing", "account_id" => @user.client.account_id}
			assigns(:client).should_not be_nil
			assigns(:client).name.should == "testing"
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