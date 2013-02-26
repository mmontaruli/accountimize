class SiteController < ApplicationController
  skip_before_filter :authorize
  def index
    @header_trial = true
  end

  def find_subdomain

  end

  def subdomain_found
    @users = User.find(:all, :conditions => {:email => params[:email]})
    if @users.length == 1
      redirect_to log_in_url(:subdomain => @users[0].client.account.subdomain)
    end
  end

end
