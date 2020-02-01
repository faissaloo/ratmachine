require "file_utils"
require "../config/*"

if User.count == 0
  puts "This seems to be your first time starting Ratmachine, you'll need to create an admin user for use on the /mod page"
  username = nil
  while username.nil? || username.blank?
    printf "Username: "
    username = gets
  end
  password = nil
  while password.nil? || password.blank?
    printf "Password: "
    password = gets
  end

  unless username.nil? || password.nil?
    User.create!(username: username.chomp, salted_hashed_password: Crypto::Bcrypt::Password.create(password.chomp).to_s)
    puts "Creating CAPTCHA directory"
    FileUtils.mkdir_p("public/dist/images/captcha")
    puts "All done!"
  end
end
Amber::Server.start
