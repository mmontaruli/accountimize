require 'spec_helper'

describe AccountsController do
	describe "#new" do
		before do
			get :new
		end
		it "should be successful" do
			response.should be_success
		end
		it "should create an account object" do
			assigns(:account).should_not be_nil
		end
	end
	describe "#create" do
    	before do
    		post :create, "account" => {"name" => "Lorem Ipsum", "subdomain" => "loremipsum", "clients_attributes" => {"0"=>{"is_account_master"=>"true", "name"=>"Lorem Ipsum", "address_street_1"=>"", "address_street_2"=>"", "address_city"=>"", "address_state"=>"", "address_zip"=>"", "country"=>"", "users_attributes"=>{"0"=>{"email"=>"lorem@ipsum.com", "password"=>"Lorem123", "password_confirmation"=>"Lorem123"}}}}}
    	end
    	it "should create a new account" do
      		assigns(:account).should_not be_nil
      		assigns(:account).name.should == "Lorem Ipsum"
    	end
    	it "should redirect to account dashboard" do
    		response.should redirect_to log_in_url(:subdomain => assigns(:account).subdomain)
    	end
  	end
end