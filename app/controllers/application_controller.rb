class ApplicationController < ActionController::Base
  include UrlHelper
  before_filter :get_section_name
  protect_from_forgery
  helper_method :current_user
  before_filter :authorize
  helper_method :signed_in_client

  private

    def get_section_name
      @section_name = params[:controller]
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def signed_in_client
      @signed_in_client ||= Client.find(current_user.client_id) if current_user
    end

    def inner_navigation
      @inner_navigation = true
    end

    def get_account
      @account = Account.find_by_subdomain(request.subdomain)
    end

    def authorize
      redirect_to log_in_path unless current_user
    end

    def restrict_access
      redirect_to site_url unless signed_in_client.is_account_master
    end

end
