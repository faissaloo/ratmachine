require "crypto/bcrypt/password"

class User < Granite::Base
  connection pg
  table filters

  column id : Int64, primary: true
  column username : String
  column salted_hashed_password : String
  timestamps

  def self.authenticate(username : String, password : String)
    user = User.find_by!(username: username)
    if Crypto::Bcrypt::Password.new(user.salted_hashed_password) == Crypto::Bcrypt::Password.new(password)
      user
    else
      nil
    end
  end
end
