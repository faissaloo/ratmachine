require "../helpers/captcha/captcha"

class ModController < ApplicationController
  def mod
    render("mod.ecr")
  end

  def render_delete_form
    form(action: "/post/delete", method: "delete") do
      csrf_tag() +
      text_field(:post_id, type: :number, placeholder: "post_id") + "<br/>" +
      text_field(:password, type: :password, placeholder: "password") +
      CaptchaHelper.captcha_form() +
      submit("delete")
    end
  end
end
