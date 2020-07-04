class AddMovieSessionIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :movie_session_id, :integer
  end
end
