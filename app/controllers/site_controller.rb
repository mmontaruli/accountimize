class SiteController < ApplicationController
  skip_before_filter :authorize
  def index
    @header_trial = true
  end

  def find_subdomain

  end

end
