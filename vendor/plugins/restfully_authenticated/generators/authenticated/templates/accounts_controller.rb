class AccountsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  before_filter :login_required, :except => :show

  # Activate action
  def show
    # Uncomment and change paths to have user logged in after activation - not recommended
    # self.current_<%= file_name %> = <%= class_name %>.find(params[:id])
    # self.current_<%= file_name %>.do_activate
    
    <%= class_name %>.find_and_activate!(params[:id])
    flash[:notice] = "Your account has been activated"
    redirect_to login_path
  rescue <%= class_name %>::ArgumentError
    flash[:error] = 'Activation code not found'
    redirect_to new_<%= file_name %>_path 
  rescue <%= class_name %>::ActivationCodeNotFound
    flash[:error] = 'Activation code not found'
    redirect_to new_user_path
  rescue <%= class_name %>::AlreadyActivated
    flash[:error] = 'Your account has already been activated'
    redirect_to login_path
  end

  def edit
    @page_title = "Change your password"
  end

  # Change password action  
  def update
    return unless request.post?
    if <%= class_name %>.authenticate(current_<%= file_name %>.email, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_<%= file_name %>.password_confirmation = params[:password_confirmation]
        current_<%= file_name %>.password = params[:password]        
    if current_<%= file_name %>.save
          flash[:notice] = "Password successfully updated"
          redirect_to "/"
        else
          flash[:error] = "An error occured, your password was not changed"
          render :action => 'edit'
        end
      else
        flash[:error] = "New password does not match the password confirmation"
        @old_password = params[:old_password]
        render :action => 'edit'      
      end
    else
      flash[:error] = "Your old password is incorrect"
      render :action => 'edit'
    end 
  end
end
