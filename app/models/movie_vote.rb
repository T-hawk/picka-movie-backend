class MovieVote < ApplicationRecord
  belongs_to :user

  #validate :user_has_not_voted, :before => :create
end
