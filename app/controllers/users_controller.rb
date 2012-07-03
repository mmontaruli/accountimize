class UsersController < ApplicationController
  skip_before_filter :authorize
  before_filter :restrict_client_access
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
  def restrict_client_access
    if params[:client_id]
      @target_client = Client.find_by_id(:client_id)
      unless signed_in_client.is_account_master
        if @target_client != signed_in_client
          redirect_to site_url
        end
      end
    end
  end
end
