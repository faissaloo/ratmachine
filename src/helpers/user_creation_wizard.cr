def user_creation_wizard
  unless ENV["AMBER_ENV"] == "production"
    username = ENV["RATMACHINE_MOD_USERNAME"]
    password = ENV["RATMACHINE_MOD_PASSWORD"]
    puts "Creating the moderator #{username} with password: #{password}"
  else
    if ENV["RATMACHINE_MOD_USERNAME"]? || ENV["RATMACHINE_MOD_PASSWORD"]?
      puts "RATMACHINE_MOD_USERNAME and RATMACHINE_MOD_PASSWORD were set but ignored because we are running in production"
    end
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
  end

  unless username.nil? || password.nil?
    User.create!(username: username.chomp, salted_hashed_password: Crypto::Bcrypt::Password.create(password.chomp).to_s)
    puts "All done!"
  end
end
