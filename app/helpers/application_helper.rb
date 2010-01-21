# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def user_logged_in?
      session[:user_id]
    end

    def medewerker_logged_in?
      if current_user.type = 'Medewerker'
          session[:user_id]
      else
          nil
      end
    end
end
