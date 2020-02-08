module Usecase
  class AuthenticateToken
    def call(token : HTTP::Cookie | Nil)
      unless token.nil?
        payload, header = JWT.decode(token.value, Authentication.secret, JWT::Algorithm::HS256)
        return { valid: true, username: payload["username"] }
      else
        return { valid: false, username: nil }
      end
    rescue JWT::VerificationError
      { valid: false, username: nil }
    end
  end
end
