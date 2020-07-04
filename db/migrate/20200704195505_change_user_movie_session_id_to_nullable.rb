class ChangeUserMovieSessionIdToNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :movie_session_id, true
  end
end
