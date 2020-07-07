FactoryBot.define do
  factory :movie_session do
    movie_refs { [create(:movie_ref)] }
    creator_id { 1 }
  end

  factory :movie_ref do
    tmdb_id { 454626 }
  end
end
