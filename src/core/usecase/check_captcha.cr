module Usecase
  class CheckCaptcha(CAPTCHA_GATEWAY)
    def call(captcha_id : String, captcha_value : String)
      unless CAPTCHA_GATEWAY.is_valid?(captcha_id, captcha_value)
        return { valid: false, status: "Incorrect or expired CAPTCHA" }
      end
      return { valid: true, status: nil }
    end
  end
end
