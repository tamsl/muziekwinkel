class AankoopsController < ApplicationController
  layout 'standard'

  before_filter :authorize, :except => [:index, :show]
  before_filter :user_authorize, :only => [:index, :show]

  def index
    @aankoops = Klant.find(params[:klant_id]).aankoops

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aankoops }
    end
  end

  def show
    @aankoop = Aankoop.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aankoop }
    end
  end

  def new
    @aankoop = Aankoop.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aankoop }
    end
  end

  def edit
    @aankoop = Aankoop.find(params[:id])
  end

  def create
    @aankoop = Aankoop.new(params[:aankoop])
    @aankoop.klant_id = current_user.id
    if @aankoop.prijs.nil?
      @aankoop.prijs = @aankoop.product.prijs
    end

    respond_to do |format|
      if @aankoop.save
        flash[:notice] = 'Aankoop was successfully created.'
        format.html { redirect_to(@aankoop.klant) }
        format.xml  { render :xml => @aankoop, :status => :created, :location => @aankoop }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aankoop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aankoops/1
  # PUT /aankoops/1.xml
  def update
    @aankoop = Aankoop.find(params[:id])

    respond_to do |format|
      if @aankoop.update_attributes(params[:aankoop])
        flash[:notice] = 'Aankoop was successfully updated.'
        format.html { redirect_to(@aankoop) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aankoop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aankoops/1
  # DELETE /aankoops/1.xml
  def destroy
    @aankoop = Aankoop.find(params[:id])
    @aankoop.destroy

    respond_to do |format|
      format.html { redirect_to(@aankoop.klant) }
      format.xml  { head :ok }
    end
  end
end
