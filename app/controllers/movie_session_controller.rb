class MovieSessionController < ApplicationController

  before_action :validate_user_in_session, :only => [:vote, :movies]
  before_action :check_active, :except => [:create, :stop, :results]

  def movies
    render json: helpers.get_session_movies_with_votes(@movie_session)
  end

  def create
    user = User.find_by(id: user_info[:id], token: user_info[:token])
    ids = params[:ids]

    if user && ids
      movies = ids.map { |id| helpers.cached_movie(id) }
      movie_session = MovieSession.create(creator_id: user.id)
      movie_session.users << user

      movies.map { |movie|
        movie_session.movie_refs.create(tmdb_id: movie.id)
      }

      if movie_session.save
        render json: helpers.get_session_movies_with_votes(movie_session)
      else
        render json: { error: "COULD NOT CREATE SESSION" }
      end
    else
      render json: { status: "INVALID USER OR MOVIE IDS" }
    end
  end

  def join
    @movie_session = MovieSession.find_by(share_token: params[:share_token])
    @user = User.find_by(id: user_info[:id], token: user_info[:token])

    if user && movie_session
      @movie_session.users << @user

      render json: helpers.get_session_movies_with_votes(@movie_session)
    else
      render json: { status: 401 }
    end
  end

  def vote
    if user_voted?(@movie_session.id, @user.id)
      MovieVote.where(movie_session_id: @movie_session.id, user_id: @user.id).destroy_all
    end

    @movie_session.movie_votes.create(tmdb_id: params[:tmdb_id], user_id: @user.id)

    render json: helpers.get_session_movies_with_votes(@movie_session)
  end

  def stop
    @movie_session = MovieSession.find(params[:movie_session_id])

    top_voted = []

    helpers.get_session_movies_with_votes(@movie_session).each do |movie|
      top_voted = top_voted.empty? ? [movie] : top_voted

      if movie[:votes] > top_voted[0][:votes]
        top_voted = [{votes: movie[:votes], id: movie[:id]}]
      elsif movie[:votes] == top_voted[0][:votes] && movie[:id] != top_voted[0][:id]
        top_voted << {votes: movie[:votes], id: movie[:id]}
      end
    end

    @movie_session.active = false
    @movie_session.movie_refs.delete_all
    top_voted.each do |movie|
      @movie_session.movie_refs.create(tmdb_id: movie[:id])
    end
    @movie_session.save

    redirect_to :action => :results
  end

  def results
    @movie_session = MovieSession.find(params[:movie_session_id])

    if !@movie_session.active
      render json: { results: helpers.get_session_movies_with_votes(@movie_session) }
    else
      render json: { status: "SESSION NOT ENDED"}
    end
  end

  private

  def user_info
    params.require(:user).permit(:id, :token)
  end

  def user_voted?(movie_session_id, user_id)
    MovieVote.where(movie_session_id: movie_session_id, user_id: user_id).exists?
  end

  def check_active
    @movie_session = MovieSession.find(params[:movie_session_id])

    if (Time.now - @movie_session.closes_at) >= 0 && @movie_session.active
      redirect_to :action => :stop
    end

    if !@movie_session.active
      redirect_to :action => :results
    end
  end

  def validate_user_in_session
    @user = User.find_by(id: user_info[:id], token: user_info[:token])
    @movie_session = MovieSession.find(params[:movie_session_id])
    if @user && @movie_session
      if !@movie_session.users.include? @user
        render json: { error: "USER NOT IN SESSION"}
      end
    else
      render json: { error: "INVALID USER OR SESSION"}
    end
  end
end
