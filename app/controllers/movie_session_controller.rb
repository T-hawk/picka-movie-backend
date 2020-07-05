class MovieSessionController < ApplicationController
  def movies
    user = User.find_by(id: user_info[:id], token: user_info[:token])
    movie_session = MovieSession.find(params[:movie_session_id])

    if helpers.valid_user_and_movie_session?(user, movie_session)
      render json: helpers.get_session_movies_with_votes(movie_session)
    else
      render json: { status: 401 }
    end
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
    user = User.find_by(id: user_info[:id], token: user_info[:token])

    if user && movie_session
      movie_session.users << user

      render json: helpers.get_session_movies_with_votes(movie_session)
    else
      render json: { status: 401 }
    end
  end

  def vote
    movie_session = MovieSession.find(params[:movie_session_id])
    user = User.find_by(id: user_info[:id], token: user_info[:token])

    if helpers.valid_user_and_movie_session?(user, movie_session)

      if user_voted?(movie_session.id, user.id)
        MovieVote.where(movie_session_id: movie_session.id, user_id: user.id).destroy_all
      end

      movie_session.movie_votes.create(tmdb_id: params[:tmdb_id], user_id: user.id)

      render json: helpers.get_session_movies_with_votes(movie_session)
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
