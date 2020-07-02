module UserHelper
  require "securerandom"
  def gen_token
    SecureRandom.hex
  end
end
