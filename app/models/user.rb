class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email, :token

  has_one :movie_session
end
