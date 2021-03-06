class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings
    refurl = request.referrer
    
    if refurl.nil? or not(refurl.include? "amazonaws" or refurl.include? "heroku")
      reset_session
    end

    sortcol = params[:sortby]
    if sortcol.nil?
       sortcol = session[:sortcol]
    end

    if !(sortcol == "title" or sortcol == "release_date")
      sortcol = ""
    end
    @sortby = sortcol

    ratings = params[:ratings].nil? ? ((session[:ratings_to_show].nil? or params[:commit] == "Refresh") ? @all_ratings : JSON.parse(session[:ratings_to_show])) : params[:ratings].keys
    
    @movies = Movie.with_ratings(ratings, sortcol)
    @ratings_to_show = ratings
    session[:ratings_to_show] = JSON.generate(ratings)
    session[:sortcol] = sortcol
      
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
