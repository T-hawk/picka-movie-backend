class MovieSessionController < ApplicationController
  def create
    user_id = params[:user_id]
    ids = params[:ids]

    if user_id and ids
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
    # retrieve session by share token
  end

  def vote
    render json: []
  end
end
