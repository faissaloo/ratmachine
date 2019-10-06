module Usecase
  class CheckMessageSize
    def call(message : String)
      if message.empty?
        return { valid: false, status: "Message empty" }
      elsif message.size > 1024
        return { valid: false, status: "Message too long" }
      end
      return { valid: true, status: nil }
    end
  end
end
