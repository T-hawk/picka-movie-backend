class MovieSession < ApplicationRecord
  before_create :generate_token, :generate_closing_at

  has_many :users
  has_many :movie_refs
  has_many :movie_votes

  belongs_to :creator, class_name: "User"

  protected

  CLOSES_AT = 30*60

  def generate_token
    self.share_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless MovieSession.exists?(share_token: random_token)
    end
  end

  def generate_closing_at
    self.active = true
    self.closes_at = Time.now + CLOSES_AT
  end

end
