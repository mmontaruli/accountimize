require 'spec_helper'

describe MessagesController do
  before(:each) do
    @user = create(:user)
    @user.client.is_account_master = true
    @user.client.save
    @request.host = "#{@user.client.account.subdomain}.test.host"
    session[:user_id] = @user.id
    @message = create(:message, user_id: @user.id)
  end
  describe "#index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "#show" do
    it "should be successful" do
      get :show, id: @message
      response.should be_success
    end
    it "should not allow access to other users" do
      new_user = create(:user)
      session[:user_id] = new_user.id
      get :show, id: @message
      response.should redirect_to site_url
    end
  end

  describe "#destroy" do
    it "should destroy message" do
      expect { post :destroy, id: @message.id }.to change(Message, :count).by(-1)
    end
  end

end
