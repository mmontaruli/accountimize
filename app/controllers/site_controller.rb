class SiteController < ApplicationController
  skip_before_filter :authorize
  def index
    @header_trial = true
  end

  def find_subdomain

  end

  def subdomain_found
  	user = User.find_by_email(params[:email])
  	if user
  		#subdomain = user.client.account.subdomain
  		redirect_to log_in_url(:subdomain => user.client.account.subdomain)
  	end
  end

end
