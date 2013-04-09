require 'spec_helper'

describe SiteController do
	describe "index" do
		it "should be successful" do
			get :index
			response.should be_success
		end
	end

	describe "find_subdomain" do
		it "should be successful" do
			get :find_subdomain
			response.should be_success
		end
	end

	describe "subdomain_found" do
		it "should be successful" do
			get :subdomain_found
			response.should be_success
		end
		it "should redirect to login for account if user email exists" do
			# user = create(:user)
			client = create(:client, users_attributes: [attributes_for(:user)])
			user = client.users.first
			get :subdomain_found, :email => user.email
			response.should redirect_to log_in_url(:subdomain => user.client.account.subdomain)
		end
	end
end