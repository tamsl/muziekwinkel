class KlantsController < ApplicationController
  # GET /klants
  # GET /klants.xml
    layout 'standardklants'
 
  def index
    @klants = Klant.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @klants }
    end
  end

  # GET /klants/1
  # GET /klants/1.xml
  def show
    @klant = Klant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @klant }
    end
  end

  # GET /klants/new
  # GET /klants/new.xml
  def new
    @klant = Klant.new
  end

  # GET /klants/1/edit
  def edit
    @klant = Klant.find(params[:id])
  end

  # POST /klants
  # POST /klants.xml
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @klant = Klant.new(params[:klant])
    @klant.register! if @klant.valid?
    if @klant.errors.empty?
      UserMailer.deliver_signup_notification(@klant)
      #self.current_user = @klant
      #redirect_back_or_default('/')
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
    @klant.suspend!
    redirect_to users_path
  end

  def unsuspend
    @klant.unsuspend!
    redirect_to users_path
  end

  def destroy
    @klant.delete!
    redirect_to users_path
  end

  def purge
    @klant.destroy
    redirect_to users_path
  end

protected
  def find_user
    @klant = user.find(params[:id])
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
    if @klant = user.find_by_email(params[:user][:email])
      @klant.forgot_password
      @klant.save
      redirect_back_or_default('/')
      flash[:notice] = "a password reset link has been sent to your email address"
    else
      flash[:alert] = "could not find a user with that email address"
    end
  end

  #reset password
  def reset_password
    @klant = user.find_by_password_reset_code(params[:id])
    return if @klant unless params[:user]

    if ((params[:user][:password] && params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
      self.current_user = @klant #for the next two lines to work
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.password = params[:user][:password]
      @klant.reset_password
      flash[:notice] = current_user.save ? "password reset success." : "password reset failed."
      redirect_back_or_default('/')
    else
      flash[:alert] = "password mismatch"
    end
  end
end
