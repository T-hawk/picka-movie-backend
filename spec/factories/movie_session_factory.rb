FactoryBot.define do
  factory :movie_session do
    association :creator, factory: :user

    after :create do |movie_session|
      create_list :movie_ref, 3, movie_session: movie_session
    end
  end

  factory :movie_ref do
    tmdb_id { random_movie }
  end

end

def random_movie
  [8619, 556574, 419704, 706510, 531876, 475430, 454626, 671, 531454, 72545, 122917, 496243, 299536, 475557, 495764, 330457, 157336, 27205, 155, 181812].sample
end
