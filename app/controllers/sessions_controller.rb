class SessionsController < ApplicationController
  skip_before_filter :authorize
  def new
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to site_url, :flash => {:notice => "Logged in!", :status => "success"}
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to log_in_path, :flash => {:notice => "Logged out!", :status => "success"}
  end
end
