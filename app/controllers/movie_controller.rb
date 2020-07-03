class MovieController < ApplicationController
  def releases
    render json: Tmdb::Movie.popular
  end

  def search
    render json: Tmdb::Movie.find(params["search"])
  end
end
