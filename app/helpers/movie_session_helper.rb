module MovieSessionHelper
  CACHE_PREFIX = "TMDB"

  def cached_movie(movie_id)
    Rails.cache.fetch("#{CACHE_PREFIX}:#{movie_id}") do
      Movie.from_tmdb_movie Tmdb::Movie.detail movie_id
    end
  end

  def format_movies(movies, movie_session_id)
    movies.map do |movie|
      votes = MovieVote.where(tmdb_id: movie.id, movie_session_id: movie_session_id)
      vote_count = votes ? votes.count : 0
      { votes: vote_count, title: movie.title, poster_path: movie.poster_path, id: movie.id }
    end
  end

  def get_session_movies_with_votes(movie_session)
    movies = movie_session.movie_refs.map do |movie_ref|
      cached_movie(movie_ref.tmdb_id)
    end

    format_movies(movies, movie_session.id)
  end

  def valid_user_and_movie_session?(user, movie_session)
    user && movie_session && movie_session.users.include?(user)
  end
end
