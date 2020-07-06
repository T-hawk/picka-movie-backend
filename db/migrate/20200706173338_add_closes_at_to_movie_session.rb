class AddClosesAtToMovieSession < ActiveRecord::Migration[6.0]
  def change
    add_column :movie_sessions, :closes_at, :datetime
  end
end
