require "set"

module Riseup
  class Spec
    @tokens : Array(String)
    def initialize(spec : Array(Array(String)))
      @spec = spec
      @spec_map = {} of String => TokenData
      @spec.each do |t|
        token : String = t[0]
        start_out : String = t[1]
        end_out : String | Nil = nil
        end_out = t[2] if t.size == 3

        @spec_map[token] = TokenData.new(start_out, end_out)
      end

      @tokens = @spec.map { |t| t[0] }
      @regex = Regex.new("(" + (@tokens.map { |t| Regex.escape(t) }).join("|") + "|[.])")
    end

    def [](key)
      @spec_map[key]
    end

    def include?(x)
      @spec_map.has_key?(x)
    end

    getter :regex

    getter :tokens
  end
end
