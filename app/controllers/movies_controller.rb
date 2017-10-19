class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort_method = params[:sort_by] if params.include? :sort_by
    sort_ratings = params["ratings"].keys if params.include? "ratings"
    @all_ratings = ["G","PG","PG-13","R","NC-17"]
    
    if(sort_method == "title")
      @movies = Movie.order(:title)
      @title_header = 'hilite'
    elsif(sort_method == "release_date")
      @movies = Movie.order(:release_date)
      @release_date_header = 'hilite'
    else
      @movies = Movie.all
    end
    
    if sort_ratings != nil
      @movies = Movie.where(rating: sort_ratings)
    end
    session[:sort_by] = sort_method
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
