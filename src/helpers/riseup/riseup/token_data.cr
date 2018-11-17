require "set"

module Riseup
  class TokenData
    @start : String | Nil
    @finish : String | Nil
    @substitute : String | Nil
    
    def initialize(start : String, finish : String | Nil = nil)
      if finish.nil?
        @start = nil
        @finish = nil
        @substitute = start
        @isSub = true
      else
        @start = start
        @finish = finish
        @substitute = nil
        @isSub = false
      end
    end

    getter :substitute

    getter :start

    getter :finish

    def substitute?
      @isSub
    end

    def all
      if substitute?
        [@substitute]
      else
        [@start, @finish]
      end
    end
  end
end
