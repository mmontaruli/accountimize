class SessionsController < ApplicationController
  skip_before_filter :authorize
  def new
  end

  def create
    #user = User.authenticate(params[:email], params[:password])
    user = User.authenticate(params[:email], params[:password], request.subdomain)
    if user
      client = Client.find_by_id(user.client_id)
      account = Account.find_by_id(client.account_id)
      if account.subdomain == request.subdomain
        session[:user_id] = user.id
        redirect_to site_url, :flash => {:notice => "Logged in!", :status => "success"}
      else
        redirect_to log_in_path, :flash => {:notice => "Invalid email or password", :status => "error"}
      end
    else
      redirect_to log_in_path, :flash => {:notice => "Invalid email or password", :status => "error"}
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to log_in_path, :flash => {:notice => "Logged out!", :status => "secondary"}
  end
end
