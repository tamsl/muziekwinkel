class WinkelwagenController < ApplicationController
  layout 'standard'

  protect_from_forgery :only => [:create, :destroy]

  def index
    if session[:products] and not session[:products].empty?
      @products = Product.find(:all, :conditions => {:id => session[:products]})
    else
      @products = []
    end
  end

  def create
    unless Product.find(:all, :conditions => ['id=?', params[:id]]).empty?
      if session[:products].nil? 
        session[:products] = [params[:id].to_i] 
      elsif not session[:products].include? params[:id].to_i
        session[:products] << params[:id].to_i
      end
      flash[:notice] = "Product is in uw winkelwagen geplaatst"
    end
    redirect_to :back
  end

  def destroy
    session[:products].delete(params[:id].to_i)
    redirect_to :back
  end

  def checkout
    if current_user
        creditcard = current_user.creditcard
        email = current_user.email
    else
        creditcard = params[:creditcard]
        email = params[:email]
    end

    for product in Product.all(:conditions => {:id => session[:products]})
        aankoop = Aankoop.new
        aankoop.klant = current_user
        aankoop.product = product
	aankoop.datum = Time.now
        aankoop.betaald = true
        aankoop.save
    end
    session[:products] = []
  end
end
