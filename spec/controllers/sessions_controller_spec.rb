require 'spec_helper'

describe SessionsController do
	before(:each) do
  		@user = create(:user)
  		@user.client.is_account_master = true
  		@user.client.save
  		@request.host = "#{@user.client.account.subdomain}.test.host"
	end
	describe "#new" do
		it "should be a success" do
			visit log_in_url
			response.should be_success
		end
	end
	describe "#create" do
		it "should log in" do
			session[:user_id] = @user.id
			visit site_url
			response.should be_success
		end
	end
	describe "#destroy" do
		it "should log out" do
			session[:user_id] = @user.id
			post 'destroy'
			session[:user_id].should be_nil
			response.should redirect_to log_in_url
		end
	end
end