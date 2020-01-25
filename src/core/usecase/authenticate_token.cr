module Usecase
  class AuthenticateToken
    def call(token : HTTP::Cookie | Nil)
      unless token.nil?
        JWT.decode(token.value, Authentication.secret, JWT::Algorithm::HS256)
        return { valid: true }
      else
        return { valid: false }
      end
    rescue JWT::VerificationError
      { valid: false }
    end
  end
end
