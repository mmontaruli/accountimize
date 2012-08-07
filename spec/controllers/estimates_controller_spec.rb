require 'spec_helper'

describe EstimatesController do
	before(:each) do
		@user = create(:user)
  		@user.client.is_account_master = true
  		@user.client.save
  		@request.host = "#{@user.client.account.subdomain}.test.host"
  		session[:user_id] = @user.id
  		@client = create(:client, account_id: @user.client.account_id)
  		@estimate = create(:estimate, client_id: @client.id)
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
	end
	describe "#create" do
		it "should create an estimate" do
			post :create, "estimate" => {"number" => "1003", "client_id" => @user.client_id, "date" => Date.today}
			assigns(:estimate).should_not be_nil
			assigns(:estimate).number.should == 1003
		end
	end
	describe "#edit" do
		it "should be successful" do
			get :edit, :id => @estimate
			response.should be_success
		end
	end
	describe "#update" do
		it "should update estimate" do
			post :update, id: @estimate.to_param, number: 200
			response.should redirect_to estimate_url(@estimate)
		end
	end
	describe "#destroy" do
		it "should destroy estimate" do
			expect { post :destroy, id: @estimate.id }.to change(Estimate, :count).by(-1)
		end
	end
end
