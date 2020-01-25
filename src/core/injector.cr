class Injector
  def self.check_filters
    Usecase::CheckFilters(Filter).new
  end

  def self.check_message_size
    Usecase::CheckMessageSize.new
  end

  def self.check_captcha
    Usecase::CheckCaptcha(Captcha).new
  end

  def self.check_root_password
    Usecase::CheckRootPassword.new
  end

  def self.check_regex_size
    Usecase::CheckRegexSize.new
  end

  def self.create_post
    Usecase::CreatePost(Post).new
  end

  def self.delete_post
    Usecase::DeletePost(Post).new
  end

  def self.check_digits
    Usecase::CheckDigits.new
  end

  def self.authenticate_token
    Usecase::AuthenticateToken.new
  end
end
