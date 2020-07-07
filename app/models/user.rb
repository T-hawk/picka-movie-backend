class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email, :token

  before_create :generate_token

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end
  end
end
