def user_creation_wizard
  puts "This seems to be your first time starting Ratmachine, you'll need to create an admin user for use on the /mod page"
  username = nil
  while username.nil? || username.blank?
    printf "Username: "
    username = gets
  end
  password = nil
  while password.nil? || password.blank?
    printf "Password: "
    STDIN.noecho do
      password = gets
    end
    puts
  end

  unless username.nil? || password.nil?
    User.create!(username: username.chomp, salted_hashed_password: Crypto::Bcrypt::Password.create(password.chomp).to_s)
    puts "All done!"
  end
end
