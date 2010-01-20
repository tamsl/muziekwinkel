class ArtiestsController < ApplicationController
  layout 'standard'

  def index
    @artiests = Product.find(:all, :select => "DISTINCT artiest").collect { |row| row.artiest }

  end

  def show
    @artiest_naam = params[:naam]
    @albums = Album.all(:conditions => ["artiest=?", @artiest_naam])
  end

  def new
  end

  def edit
  end

end
