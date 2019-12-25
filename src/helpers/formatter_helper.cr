module FormatterHelper
	def self.escape(str : String)
		str.gsub(/[&><"'#;]/, {"&": "&amp;", ">": "&gt;", "<": "&lt;", "\"": "&quot;", "'": "&#39;", "#": "&#x23;", ";": "&#x3B;"})
	end

	def self.rxEsc(str : String)
		Regex.escape(escape(str))
	end

	def self.format(str : String)
		escaped_str = self.escape(str)
		escaped_str = escaped_str.gsub(/^(?<!\\)#{rxEsc(">")}(.*)$/m, "<span class=\"greentext\">#{escape(">")}\\1</span>")
		escaped_str = escaped_str.gsub(/^(?<!\\)#{rxEsc("<")}(.*)$/m, "<span class=\"bluetext\">#{escape("<")}\\1</span>")
		escaped_str = escaped_str.gsub("\n", "<br/>")
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("`")}(.*)(?<!\\)#{rxEsc("`")}/, "<code>\\1</code>") #Bug: Things will be interpretted as formatting within the code tag
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("==")}(.*)(?<!\\)#{rxEsc("==")}/, "<span class=\"redtext\">\\1</span>")
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("%%")}(.*)(?<!\\)#{rxEsc("%%")}/, "<span class=\"spoiler\">\\1</span>")
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("$$")}(.*)(?<!\\)#{rxEsc("$$")}/, "<span class=\"shaketext\">\\1</span>")
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("$")}(.*)(?<!\\)#{rxEsc("$")}/, "<span class=\"rainbowtext\">\\1</span>")
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("#")}(.*)(?<!\\)#{rxEsc("#")}/, "<span class=\"threedtext\">\\1</span>")
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("!!")}(.*)(?<!\\)#{rxEsc("!!")}/, "<span class=\"glow\">\\1</span>")
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("**")}(.*)(?<!\\)#{rxEsc("**")}/, "<b>\\1</b>")
		escaped_str = escaped_str.gsub(/(?<!\\)#{rxEsc("*")}(.*)(?<!\\)#{rxEsc("*")}/, "<i>\\1</i>")
		escaped_str = escaped_str.gsub("\\","")
	end

  #Restore this later
	#@@formatted_headings = Rails.configuration.headings.map {|str| format(str)}

	#Picks a random heading out to be displayed
	#def self.heading
	#	@@formatted_headings.sample
	#end
end
