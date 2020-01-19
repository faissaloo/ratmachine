require "random/secure"

class Authentication
  @@hmac_secret = Random::Secure.urlsafe_base64

  def self.secret
    @@hmac_secret
  end
end
