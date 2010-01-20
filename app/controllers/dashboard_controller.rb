# This controller handles the login/logout function of the site.  
class DashboardController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  before_filter :login_required
  
  # render index.rhtml which will map to the root
  def index
    @page_title = "Dashboard"
  end
end
