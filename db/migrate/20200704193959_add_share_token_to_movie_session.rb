class AddShareTokenToMovieSession < ActiveRecord::Migration[6.0]
  def change
    add_column :movie_sessions, :share_token, :string
  end
end
