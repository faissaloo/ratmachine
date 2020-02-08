require "file_utils"
require "../config/*"
require "./helpers/user_creation_wizard"
require "./helpers/captcha/captcha"
require "./helpers/database"

initialize_database
initialize_captcha_directory
if User.count == 0
  user_creation_wizard
end

Amber::Server.start
