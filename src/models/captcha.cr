class Captcha < Granite::Base
  adapter pg
  table_name captchas

  field value : String
  timestamps

  def self.generate_captcha_string(length)
    string = ""
    length.times do
      string += ('a'.ord+Random.rand(26)).chr
    end
    string
  end

  def self.generate()
    new_captcha = Captcha.create(value: generate_captcha_string(6))

    Captcha.all("WHERE created_at < (NOW() - INTERVAL '5 minutes')").each do |record|
      begin
        File.delete("public/dist/images/captcha/#{record.id}.png")
      rescue
      end
      record.destroy
    end

    Process.run("sh",["-c","convert -font DejaVu-Sans -fill black -background transparent -size 192x64 -wave #{Random.rand(4)}x#{Random.rand(64)} -gravity Center -pointsize #{32+Random.rand(16)} -implode 0.#{Random.rand(3)} label:#{new_captcha.value} png:- 2>&1 > public/dist/images/captcha/#{new_captcha.id}.png"])
    new_captcha
  end


  def self.is_valid?(id, value)
    found_captcha = Captcha.find(id)
    return false if found_captcha.nil?
    found_captcha.value == value
  end
end
