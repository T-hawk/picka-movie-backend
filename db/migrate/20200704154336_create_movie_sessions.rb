class CreateMovieSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :movie_sessions do |t|
      t.integer :creator_id

      t.timestamps
    end
  end
end
