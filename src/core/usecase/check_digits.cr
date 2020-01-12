require "math"

module Usecase
  class CheckDigits
    def call(post_id : Int64?)
      remaining_digits, current_digit = post_id.divmod(10)
      clear = current_digit == 0
      checked = 1
      while remaining_digits%10 == current_digit && remaining_digits != 0
        checked += 1
        clear |= current_digit == 0
        remaining_digits, current_digit = remaining_digits.divmod(10)
      end

      {
        checked: checked, # How many consecutive digits are at the start of the number
        clear: clear # Are the consecutive digits all zero?
      }
    end
  end
end
