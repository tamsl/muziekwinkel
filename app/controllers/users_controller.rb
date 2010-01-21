class UsersController < ApplicationController
  ssl_required :create
  # Be sure to include AuthenticationSystem in Application Controller instead
  layout 'standard'

  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = Klant.new(params[:user])
    @user.register! if @user.valid?
    if @user.errors.empty?
      UserMailer.deliver_signup_notification(@user)
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : user.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "signup complete!"
    end
    redirect_back_or_default('/')
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

protected
  def find_user
    @user = user.find(params[:id])
  end

  def change_password
    return unless request.post?
    if user.authenticate(current_user.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]

        if current_user.save
          flash[:notice] = "password successfully updated" 
          redirect_to profile_url(current_user.login)
        else
          flash[:alert] = "password not changed" 
        end

      else
        flash[:alert] = "new password mismatch" 
        @old_password = params[:old_password]
      end
    else
        flash[:alert] = "old password incorrect"
    end
  end

  #gain email address
  def forgot_password
    return unless request.post?
    if @user = user.find_by_email(params[:user][:email])
      @user.forgot_password
      @user.save
      redirect_back_or_default('/')
      flash[:notice] = "a password reset link has been sent to your email address" 
    else
      flash[:alert] = "could not find a user with that email address" 
    end
  end

  #reset password
  def reset_password
    @user = user.find_by_password_reset_code(params[:id])
    return if @user unless params[:user]

    if ((params[:user][:password] && params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
      self.current_user = @user #for the next two lines to work
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.password = params[:user][:password]
      @user.reset_password
      flash[:notice] = current_user.save ? "password reset success." : "password reset failed." 
      redirect_back_or_default('/')
    else
      flash[:alert] = "password mismatch" 
    end 
  end

end
