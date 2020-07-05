Rails.application.routes.draw do
  scope "/api" do
    defaults format: :json do
      # User

      get "/user/:user_id", to: "user#index"
      post "/login", to: "user#login"
      post "/user/create", "user#create"

      # Movie

      get "/releases", to: "movie#releases"
      get "/search", to: "movie#search"

      # Library

      #get "/library/movies/:library_id", to: "library#movies"
      #post "/library/add/:library_id", to: "library#add"
      #delete "/library/remove/:library_id", to: "library#delete"

      # Movie session

      #get "/session/movies/:session_id", to: "movie_session#movies"
      #get "/results/movies/:session_id", to: "movie_session#movies"
      post "/session/create", to: "movie_session#create"
      post "/session/join", to: "movie_session#join"
      #post "/session/stop/:session_id", to: "movie_session#stop"
      post "/session/vote/:movie_session_id", to: "movie_session#vote"

    end
  end

  get "/", to: "page#index"
  get "/*path", to: "page#index"
end
