class ApplicationController < ActionController::Base
  before_filter :get_section_name
  protect_from_forgery
  
  private
    
    def get_section_name
      @section_name = params[:controller]
    end
end
