module Usecase
  class CheckFilters(FILTER_GATEWAY)
    def call(message : String)
      severity = FILTER_GATEWAY.filter_severity(message)
      unless severity.nil?
        return { valid: false, status: "You just posted cringe, you are going to lose subscribers"}
      end
      return { valid: true, status: nil }
    end
  end
end
