require "./riseup"
module FormatterHelper
	def self.escape(str : String)
		str.gsub(/[&><"'#;]/, {"&": "&amp;", ">": "&gt;", "<": "&lt;", "\"": "&quot;", "'": "&#39;", "#": "&#x23;", ";": "&#x3B;"})
	end

	@@spec = Riseup::Spec.new(
    [
      [escape("\n"),"<br/>"],
  		[escape("\\="),escape("=")],
  		[escape("\\$"),escape("$")],
  		[escape("\\%"),escape("%")],
  		[escape("\\`"),escape("`")],
  		[escape("\\*"),escape("*")],
  		[escape("\\#"),escape("#")],
  		[escape("=="),"<span class=\"redtext\">","</span>"],
  		[escape("%%"),"<span class=\"spoiler\">","</span>"],
  		[escape("$$"),"<span class=\"shaketext\">","</span>"],
  		[escape("$"),"<span class=\"rainbowtext\">","</span>"],
  		[escape("#"),"<span class=\"threedtext\">","</span>"],
  		[escape("`"), "<code>","</code>"],
  		[escape("**"),"<b>","</b>"],
  		[escape("*"),"<i>","</i>"],
		]
  )

	def self.format(str : String)
		Riseup::Parser.new(self.escape(str),@@spec).parse
	end

  #Restore this later
	#@@formatted_headings = Rails.configuration.headings.map {|str| format(str)}

	#Picks a random heading out to be displayed
	#def self.heading
	#	@@formatted_headings.sample
	#end
end
