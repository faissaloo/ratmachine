module Usecase
  class CheckRegexSize
    def call(regex : String)
      if regex.size > 1024
        return { valid: false, status: "Regex too long" }
      end
      return { valid: true, status: nil }
    end
  end
end
