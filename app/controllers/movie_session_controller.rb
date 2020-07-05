class MovieSessionController < ApplicationController
  def create
    user_id = params[:user_id]
    ids = params[:ids]

    if user_id && ids
      movies = ids.map { |id| helpers.cached_movie(id) }
      movie_session = MovieSession.create(creator_id: user_id)

      movies.map { |movie|
        movie_session.movie_refs.create(tmdb_id: movie.id)
      }

      if movie_session.save
        render json: movies
      else
        render json: { status: 401 }
      end
    else
      render json: { status: 401 }
    end
  end

  def join
    movie_session = MovieSession.find_by(share_token: params[:share_token])

    if params[:user_id] && movie_session
      movie_session.users << User.find(params[:user_id])
      render json: { status: "OK" }
    else
      render json: { status: 401 }
    end
  end

  def vote
    movie_session = MovieSession.find(params[:movie_session_id])
    user = User.find_by(id: user_info[:id], token: user_info[:token])

    if user && movie_session && movie_session.users.include?(user)

      if user_voted?(movie_session.id, user.id)
        MovieVote.where(movie_session_id: movie_session.id, user_id: user.id).destroy_all
      end

      movie_session.movie_votes.create(tmdb_id: params[:tmdb_id], user_id: user.id)
      movies = movie_session.movie_refs.map do |movie_ref|
        helpers.cached_movie(movie_ref.tmdb_id)
      end

      movies = helpers.format_movies(movies, movie_session.id)

      render json: movies
    else
      render json: { status: 401 }
    end
  end

  private

  def user_info
    params.require(:user).permit(:id, :token)
  end

  def user_voted?(movie_session_id, user_id)
    MovieVote.where(movie_session_id: movie_session_id, user_id: user_id).exists?
  end
end
