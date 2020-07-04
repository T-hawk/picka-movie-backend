class AddMovieRefAndMovieVote < ActiveRecord::Migration[6.0]
  def change
    create_table :movie_refs do |t|
      t.integer :movie_session_id
      t.integer :tmdb_id
    end

    create_table :movie_votes do |t|
      t.integer :movie_session_id
      t.integer :tmdb_id
      t.integer :user_id
    end
  end
end
