require "../helpers/captcha/captcha"

class ModController < ApplicationController
  @post_to_action : Int32 | Nil
  def mod
    id = params[:id]?
    unless id.nil?
      @post_to_action = id.to_i
    end

    render("mod.ecr")
  end

  def render_thread(parent : Post | Nil = nil)
  	content(element_name: :div, options: {class: "post"}.to_h) do
  		unless parent.nil?
  		  select_button = content(element_name: :a, content: "Select", options: {
  				href: "/mod/#{parent.id.to_s}#reply-#{parent.id.to_s}",
  				id: "reply-#{parent.id.to_s}"}.to_h) + " " +
  				parent.id.to_s + " " +
  				parent.created_at.to_s #("%d/%m/%Y %H:%M")
  		else
  			select_button = content(element_name: :a, content: "Deselect", options: {href: "/mod/#top", id: "top"}.to_h)
  		end
  		post_content = content(element_name: :div, options: {class: "post_content"}.to_h) do
  			content(element_name: :p, options: {class: "post_text"}.to_h) do
  				parent.html unless parent.nil? #.html_safe
  			end
  		end

  		child_posts = Post.get_replies(parent).map do |post|
  			render_thread(post).as(String)
  		end.join("<br/>")
  		select_button +
      "<br/>" + post_content + child_posts
  	end
  end

  def get_mod_form_title()
    return "Mod tools <br/>" if @post_to_action.nil?
    "Mod tools for post #{@post_to_action} <br/>"
  end

  def render_delete_form()
    unless @post_to_action.nil?
      content(element_name: :div, options: {class: "form"}.to_h) do
        get_mod_form_title() +
        form(action: "/post/delete", method: "delete") do
          csrf_tag() +
          hidden_field(:post_id, value: @post_to_action) +
          text_field(:password, type: :password, placeholder: "password") +
          CaptchaHelper.captcha_form() +
          submit("delete")
        end
      end
    end
  end
end
