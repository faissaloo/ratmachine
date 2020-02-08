require "./captcha/form_helper"

def initialize_captcha_directory
  FileUtils.mkdir_p("public/dist/images/captcha")
end
