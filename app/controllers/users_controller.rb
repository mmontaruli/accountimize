class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to site_url, :flash => {:notice => "Signed up!", :status => "success"}
    else
      render "new"
    end
  end
end
