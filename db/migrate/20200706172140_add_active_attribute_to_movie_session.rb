class AddActiveAttributeToMovieSession < ActiveRecord::Migration[6.0]
  def change
    add_column :movie_sessions, :active, :boolean
  end
end
