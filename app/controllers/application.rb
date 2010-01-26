# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem#, SslRequirement
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '347d4ae08cabdea38255813e135476a9'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
 
    protected
    
    def authorize
	  unless user_is_medewerker?
	    redirect_back_or_default('/login')
	    false
	  end
    end

    def user_authorize
      unless user_is_medewerker? or current_user.id == params[:id].to_i
        redirect_back_or_default('/login')
        false
      end
    end

    def user_is_medewerker?
        session[:user_id] and current_user.class == Medewerker
    end
end
