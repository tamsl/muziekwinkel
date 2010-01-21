class UitgelichtsController < ApplicationController
  # GET /uitgelichts
  # GET /uitgelichts.xml
  def index
    @uitgelichts = Uitgelicht.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @uitgelichts }
    end
  end

  # GET /uitgelichts/1
  # GET /uitgelichts/1.xml
  def show
    @uitgelicht = Uitgelicht.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @uitgelicht }
    end
  end

  # GET /uitgelichts/new
  # GET /uitgelichts/new.xml
  def new
    @uitgelicht = Uitgelicht.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @uitgelicht }
    end
  end

  # GET /uitgelichts/1/edit
  def edit
    @uitgelicht = Uitgelicht.find(params[:id])
  end

  # POST /uitgelichts
  # POST /uitgelichts.xml
  def create
    @uitgelicht = Uitgelicht.new(params[:uitgelicht])

    respond_to do |format|
      if @uitgelicht.save
        flash[:notice] = 'Uitgelicht was successfully created.'
        format.html { redirect_to(@uitgelicht) }
        format.xml  { render :xml => @uitgelicht, :status => :created, :location => @uitgelicht }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @uitgelicht.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /uitgelichts/1
  # PUT /uitgelichts/1.xml
  def update
    @uitgelicht = Uitgelicht.find(params[:id])

    respond_to do |format|
      if @uitgelicht.update_attributes(params[:uitgelicht])
        flash[:notice] = 'Uitgelicht was successfully updated.'
        format.html { redirect_to(@uitgelicht) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @uitgelicht.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /uitgelichts/1
  # DELETE /uitgelichts/1.xml
  def destroy
    @uitgelicht = Uitgelicht.find(params[:id])
    @uitgelicht.destroy

    respond_to do |format|
      format.html { redirect_to(uitgelichts_url) }
      format.xml  { head :ok }
    end
  end
end
