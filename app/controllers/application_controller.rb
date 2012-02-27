class ApplicationController < ActionController::Base
  include UrlHelper
  before_filter :get_section_name
  protect_from_forgery
  helper_method :current_user
  before_filter :authorize
  
  private
    
    def get_section_name
      @section_name = params[:controller]
    end
    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def inner_navigation
      @inner_navigation = true
    end
    
    def get_account
      @account = Account.find(params[:account_id])
    end
    
    def authorize
      if current_user
        #redirect_to current_user if User.find(params[:id]).id != current_user.id
      else
        redirect_to log_in_path
      end
    end
end
