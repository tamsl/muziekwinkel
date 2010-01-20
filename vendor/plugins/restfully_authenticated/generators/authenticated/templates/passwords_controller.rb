class PasswordsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Enter email address to recover password 
  def new
    @page_title = "Forgot your password?"
  end
 
  # Forgot password action
  def create
    return unless request.post?
    if @<%= file_name %> = <%= class_name %>.find_for_forget(params[:email])
      @<%= file_name %>.forgot_password
      @<%= file_name %>.save      
      flash[:notice] = "A password reset link has been sent to your email address"
      redirect_to login_path
    else
      flash[:error] = "Sorry, we could not find an activated user with that email address"
      render :action => 'new'
    end  
  end
  
  # Action triggered by clicking on the /reset_password/:id link recieved via email
  # Makes sure the id code is included
  # Checks that the id code matches a user in the database
  # Then if everything checks out, shows the password reset fields
  def edit
    @page_title = "Reset your password"
    if params[:id].nil?
      render :action => 'new'
      return
    end
    @<%= file_name %> = <%= class_name %>.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @<%= file_name %>.nil?
  rescue
    flash[:error] = "Sorry, that is an invalid password reset code"
    redirect_back_or_default('/')
  end
    
  # Reset password action /reset_password/:id
  # Checks once again that an id is included and makes sure that the password field isn't blank
  def update
    if params[:id].nil?
      render :action => 'new'
      return
    end
    if params[:password].blank?
      flash[:error] = "Password field cannot be blank"
      render :action => 'edit', :id => params[:id]
      return
    end
    @<%= file_name %> = <%= class_name %>.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @<%= file_name %>.nil?
    return if @<%= file_name %> unless params[:password]
    if (params[:password] == params[:password_confirmation])
      self.current_<%= file_name %> = @<%= file_name %> # for the next two lines to work
      current_<%= file_name %>.password_confirmation = params[:password_confirmation]
      current_<%= file_name %>.password = params[:password]
      @<%= file_name %>.reset_password
      if current_<%= file_name %>.save
        flash[:notice] = "Password reset"
      else
        flash[:error] = "Password not reset"
      end
    else
      flash[:error] = "Password mismatch"
      render :action => 'edit', :id => params[:id]
      return
    end  
    redirect_to login_path
  rescue
    flash[:error] = "Sorry, that is an invalid password reset code"
    redirect_to new_<%= file_name %>_path
  end
end
