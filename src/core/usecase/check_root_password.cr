module Usecase
  class CheckRootPassword
    def call(password : String)
      secrets = Amber.settings.secrets
      if secrets.nil?
        return { valid: false, status: "No root password is set"}
      end

      unless password == secrets["root_password"]
        return { valid: false, status: "Invalid password"}
      end
      return { valid: true, status: nil }
    end
  end
end
