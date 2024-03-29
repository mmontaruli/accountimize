require 'spec_helper'

describe PasswordResetsController do
  before(:each) do
  	# @user = create(:user)
  	# @user.client.is_account_master = true
  	# @user.client.save
    vendor = create(:client, is_account_master: true, users_attributes: [attributes_for(:user)])
    @user = vendor.users.first
  	@request.host = "#{@user.client.account.subdomain}.test.host"
  end
  describe "#new" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  end
  describe "#create" do
  	it "should reset password" do
  	  post :create, user: @user
  	  response.should redirect_to log_in_url
  	end
    it "should create a token for the right user" do
      new_client = create(:client, users_attributes: [attributes_for(:user, email: @user.email)])
      new_user = new_client.users.first
      @request.host = "#{new_user.client.account.subdomain}.test.host"
      post :create, email: new_user.email
      User.find(new_user).password_reset_token.should_not be_nil
      User.find(@user).password_reset_token.should be_nil
    end
  end
  describe "#edit" do
  	it "should be successful" do
  		@user.generate_token(:password_reset_token)
  	  @user.save!
  		get :edit, id: @user.password_reset_token
  		response.should be_success
  	end
  end
  describe "#update" do
    it "should update user password if reset has not expired" do
      @user.generate_token(:password_reset_token)
      @user.password_reset_sent_at = Time.zone.now
      @user.save
      post :update, id: @user.password_reset_token, user: {password: "Freddie123", password_confirmation: "Freddie123"}
      response.should redirect_to log_in_url
      flash[:notice].should == "Password has been reset!"
    end
    it "should not update user password if reset has expired" do
      @user.generate_token(:password_reset_token)
      @user.password_reset_sent_at = Time.zone.now - 2.day
      @user.save
      post :update, id: @user.password_reset_token, user: {password: "Freddie123", password_confirmation: "Freddie123"}
      flash[:alert].should == "Password reset has expired."
    end
  end

end
