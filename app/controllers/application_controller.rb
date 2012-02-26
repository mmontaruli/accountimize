class ApplicationController < ActionController::Base
  before_filter :get_section_name
  protect_from_forgery
  helper_method :current_user
  
  private
    
    def get_section_name
      @section_name = params[:controller]
    end
    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
end
