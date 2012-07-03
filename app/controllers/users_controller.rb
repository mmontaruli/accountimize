class UsersController < ApplicationController
  skip_before_filter :authorize
  before_filter :get_account
  before_filter :restrict_account_access
  def new
    @user = User.new
    @client = Client.find_by_id(params[:client_id])
    @user.client_id = @client.id if @client
  end

  def create
    @user = User.new(params[:user])
    @client = Client.find_by_id(@user.client_id)
    if @user.save
      redirect_to client_path(@client), :flash => {:notice => "Signed up!", :status => "success"}
    else
      render "new"
    end
  end

  private
  def restrict_account_access
    if params[:client_id]
      @client = Client.find_by_id(params[:client_id])
      @user_account = Account.find_by_id(@client.account_id)
      if @user_account != @account
        redirect_to site_url
      end
    end
  end
end
