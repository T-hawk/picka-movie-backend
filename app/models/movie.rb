class Movie
  attr_accessor :title, :poster_path, :id

  def self.from_tmdb_movie(movie)
    output = Movie.new(movie["title"], movie["poster_path"], movie["id"])
  end

  def initialize(title, poster_path, id)
    @title = title
    @poster_path = poster_path
    @id = id
  end
end
