class HomeController < ApplicationController
  layout 'standard'
  def index
  end

  def disclaimer
  end

  def genre
    @albums = Product.all(:conditions => ["type = 'Album' and LOWER(genre) = ?", params[:genre].downcase], :order => ":artiest ASC")
    @genrenaam = Product.all(:conditions => ["type = 'Album' and LOWER(genre) = ?", params[:genre].downcase], :order => ":artiest ASC", :limit => 1)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @albums }
    end
  end

  def search
    [:artiest, :album, :song].each { |n|
        if params[n].nil? or params[n].empty?
          params[n] = '%'
        else
          params[n] = '%' + params[n] + '%'
        end
    }

    if params[:song] == '%'
      @products = Album.find(:all, :conditions => ['titel like ? AND artiest like ?', params[:album], params[:artiest]])
      @query_type = :album
    else
      @products = Nummer.find(:all, :conditions => ['titel like ? AND artiest like ?', params[:song], params[:artiest]])
      @query_type = :song
    end

    respond_to do |format|
      format.html
    end
  end

  def aanbevelingen
    genres = current_user.products.count(:group => :genre)
    @albums = []
    while @albums.length < 10 and not genres.empty?
      most_bought = genres.pop[0]
      albums = Album.all(:conditions => {:genre => most_bought}, :limit => 10)
      @albums += albums.reject { |a| current_user.products.include? a }
    end
    @albums = @albums[0..9]
  end

end
