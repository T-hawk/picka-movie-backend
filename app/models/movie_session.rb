class MovieSession < ApplicationRecord
  before_create :generate_token

  has_many :users
  has_many :movie_refs
  has_many :movie_votes

  belongs_to :creator, class_name: "User"

  protected

  def generate_token
    self.share_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless MovieSession.exists?(share_token: random_token)
    end
  end
end
