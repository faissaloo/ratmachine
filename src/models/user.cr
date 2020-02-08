require "crypto/bcrypt/password"

class User < Granite::Base
  connection pg
  table users

  column id : Int64, primary: true
  column username : String
  column salted_hashed_password : String
  timestamps

  def self.authenticate(username : String, password : String)
    user = User.find_by!(username: username)
    if Crypto::Bcrypt::Password.new(user.salted_hashed_password) == password
      user
    else
      nil
    end
  rescue Granite::Querying::NotFound
    nil
  end

  def to_s
    "<#{@username}: #{@salted_hashed_password}>"
  end
end
