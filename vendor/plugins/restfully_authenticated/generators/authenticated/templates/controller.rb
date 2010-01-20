# This controller handles the login/logout function of the site.  
class <%= controller_class_name %>Controller < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
    @page_title = "Log in"
  end

  def create
    password_authentication(params[:email], params[:password])
  end

  def password_authentication(email, password)
    <%= file_name %> = <%= class_name %>.authenticate(email, password)
    if <%= file_name %> == nil
      failed_login("Your email or password may be incorrect. Did you forget to activate your account?")
    elsif <%= file_name %>.state == "suspended"
      failed_login("Your account has been disabled")
    else
      self.current_<%= file_name %> = <%= file_name %>
      successful_login
    end
  end
  
  def destroy
    self.current_<%= file_name %>.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_to signup_path
    flash[:notice] = "You have been logged out"
  end
  
  private

  def failed_login(message)
    flash[:error] = message
    render :action => 'new'
  end

  def successful_login
    if params[:remember_me] == "1"
      current_<%= file_name %>.remember_me unless current_<%= file_name %>.remember_token?
      cookies[:auth_token] = { :value => self.current_<%= file_name %>.remember_token , :expires => self.current_<%= file_name %>.remember_token_expires_at }
    end
    flash[:notice] = "Logged in successfully"
    redirect_back_or_default('/')
  end
end
