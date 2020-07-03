class MovieSessionController < ApplicationController
  def create
    movies = ids.map { |id| helpers.cached_movie(id) }
    render json: movies
  end

  def vote
    render json: []
  end

  def ids
    params.require("ids")
  end
end
