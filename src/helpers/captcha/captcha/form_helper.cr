require "jasper_helpers"
include JasperHelpers
module CaptchaHelper

  def self.captcha_form()
    new_captcha = Captcha.generate()
    content(element_name: :div, options: {class: "captcha_form"}.to_h) do
      content(element_name: :img, content: "", options: {src: "/dist/images/captcha/#{new_captcha.id.to_s}.png", alt: "captcha"}.to_h) + "<br/>" +
      hidden_field(:captcha_id, value: new_captcha.id) + "<br/>" +
      text_field(:captcha_value, placeholder: "captcha") + "<br/>"
    end
  end
end
