require 'spec_helper'

describe InvoicesController do
	before(:each) do
		@user = create(:user)
  		@user.client.is_account_master = true
  		@user.client.save
  		@request.host = "#{@user.client.account.subdomain}.test.host"
  		session[:user_id] = @user.id
  		@client = create(:client, account_id: @user.client.account_id)
  		@invoice = create(:invoice, client_id: @client.id)
  		@client_user = create(:user, client_id: @client.id)
	end
	describe "#index" do
		it "should be successful" do
			get :index
			response.should be_success
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
		it "should create an invoice" do
			post :create, "invoice" => {"number" => "2004", "client_id" => @user.client_id, "date" => Date.today}
			assigns(:invoice).should_not be_nil
			assigns(:invoice).number.should == 2004
		end
	end
	describe "#edit" do
		it "should be successful" do
			get :edit, id: @invoice
			response.should be_success
		end
		it "should not allow access to client" do
			session[:user_id] = @client_user.id
			get :edit, id: @invoice
			response.should redirect_to site_url
		end
	end
	describe "#update" do
		it "should update invoice" do
			post :update, id: @invoice.to_param, number: 900
			response.should redirect_to invoice_url(@invoice)
		end
	end
	describe "#destroy" do
		it "should destory invoice" do
			expect { post :destroy, id: @invoice.id }.to change(Invoice, :count).by(-1)
		end
	end
end
