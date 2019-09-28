class Captcha < Granite::Base
  connection pg
  table captchas

  column id : Int64, primary: true
  column value : String
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

    Captcha.where(:created_at, :lt, Time.utc - 5.minutes).each do |captcha|
      captcha.destroy
    end

    Process.run("sh",["-c","convert -font DejaVu-Sans -fill black -background transparent -size 192x64 -wave #{Random.rand(4)}x#{Random.rand(64)} -gravity Center -pointsize #{32+Random.rand(16)} -implode 0.#{Random.rand(3)} label:#{new_captcha.value} png:- 2>&1 > public/dist/images/captcha/#{new_captcha.id}.png"])
    new_captcha
  end

  def delete()
    begin
      File.delete("public/dist/images/captcha/#{id}.png")
    rescue
    end
    destroy()
  end

  def self.is_valid?(id, value, destroy = true)
    found_captcha = Captcha.find(id)
    return false if found_captcha.nil?
    found_captcha_value = found_captcha.value
    found_captcha.delete() if destroy
    found_captcha_value == value
  end
end
