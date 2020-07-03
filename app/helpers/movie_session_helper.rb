module MovieSessionHelper
  CACHE_PREFIX = "TMDB"

  def cached_movie(movie_id)
    Rails.cache.fetch("#{CACHE_PREFIX}:#{movie_id}") do
      Movie.from_tmdb_movie Tmdb::Movie.detail movie_id
    end
  end
end
