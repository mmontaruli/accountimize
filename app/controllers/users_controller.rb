class UsersController < ApplicationController
  skip_before_filter :authorize
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
end
