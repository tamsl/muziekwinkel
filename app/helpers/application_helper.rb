# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def user_logged_in?
      session[:user_id]
    end

    def medewerker_logged_in?
      session[:user_id] and current_user.type == 'medewerker'
    end
end
