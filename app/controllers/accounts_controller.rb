class AccountsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  before_filter :login_required, :except => :show

  # Activate action
  def show
    # Uncomment and change paths to have user logged in after activation - not recommended
    # self.current_user = User.find(params[:id])
    # self.current_user.do_activate
    
    User.find_and_activate!(params[:id])
    flash[:notice] = "Your account has been activated"
    redirect_to login_path
  rescue User::ArgumentError
    flash[:error] = 'Activation code not found'
    redirect_to new_user_path 
  rescue User::ActivationCodeNotFound
    flash[:error] = 'Activation code not found'
    redirect_to new_user_path
  rescue User::AlreadyActivated
    flash[:error] = 'Your account has already been activated'
    redirect_to login_path
  end

  def edit
    @page_title = "Change your password"
  end

  # Change password action  
  def update
    return unless request.post?
    if User.authenticate(current_user.email, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]        
    if current_user.save
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
