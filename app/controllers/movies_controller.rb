class MoviesController < ApplicationController
  before_filter :find_movie, only: %i[show edit update destroy from_same_director]

  def index
    @all_ratings = Movie.all_ratings

    session[:sort_by] = params[:sort_by] if params[:sort_by]

    if params[:ratings]
      session[:ratings] = params[:ratings]
      @ratings = session[:ratings].keys
    else
      if params[:utf8] # Form is submitted with all ratings unchecked
        @ratings = []
      elsif session[:ratings]
        flash.keep
        redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
      else
        @ratings = @all_ratings
      end
    end

    @movies = Movie.order(session[:sort_by]).where('rating IN (?)', @ratings)
  end

  def show
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(params[:movie])
    if @movie.save
      flash[:notice] = "'#{@movie.title}' was successfully created."
    end
    respond_with @movie, location: movies_path
  end

  def edit
  end

  def update
    if @movie.update_attributes(params[:movie])
      flash[:notice] = "'#{@movie.title}' was successfully updated."
    end
    respond_with @movie, location: movie_path(@movie)
  end

  def destroy
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    respond_with @movie, location: movies_path
  end

  def from_same_director
    if @movie.director.blank?
      redirect_to movies_path, notice: "'#{@movie.title}' has no director info"
    else
      @movies_from_same_director = @movie.other_movies_from_same_director
    end
  end

  private

  def find_movie
    @movie = Movie.find(params[:id])
  end
end
