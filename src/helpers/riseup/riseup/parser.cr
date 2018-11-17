require "set"
module Riseup
  class Parser
    @tokens : Array(String)
    # This is a super basic markup language, none of the characters here are unsafe for HTML
    @@default_spec = Spec.new([
                                # Escapes
                                ["\\*", "*"],
                                ["\\=", "="],
                                ["\\`", "`"],
                                ["\\\\", "\\"],
                                # Bold
                                ["**", "<b>", "</b>"],
                                # Italic
                                ["*", "<i>", "</i>"],
                                # Header
                                ["=", "<h1>", "</h2>"],
                                # Code
                                ["`", "<code>", "</code>"],
                                # Newline
                                ["\n", "<br/>"]
                              ])

    def initialize(unformated : String, spec : Spec = @@default_spec)
      @unformated = unformated
      @spec = spec
      @tokens = [] of String
      tokens
    end

    def tokens
      @tokens = @unformated.split(@spec.regex).reject do |t|
        t.empty?
      end
    end

    def parse
      tokens if @tokens.nil?

      token_toggle = [] of String
      new_html = [] of String
      @tokens.each do |t|
        #This right here is failing, why?
        if @spec.include?(t)
          if token_toggle.includes?(t)

            token_toggle.delete(t)
            token : TokenData = @spec[t]
            new_html << token.finish.as(String) unless @spec[t].substitute?
          else
            if !@spec[t].substitute?
              token_toggle << t
              new_html << @spec[t].start.as(String)
            else
              new_html << @spec[t].substitute.as(String)
            end
          end
        else
          new_html << t
        end
      end

      # Fix unterminated tokens
      token_toggle.reverse.each do |token|
        new_html << @spec[token].finish.as(String) unless @spec[token].substitute?
      end


      new_html.join
    end

    def to_s
      @tokens.to_s
    end
  end
end
