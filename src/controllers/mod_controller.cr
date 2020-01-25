require "jwt"
require "../helpers/captcha/captcha"

class ModController < ApplicationController
  @post_to_action : Int32 | Nil
  def login_page
    render("login_page.ecr")
  end

  def authenticate
    user = User.authenticate(username: params[:username], password: params[:password])

    if user.nil? || !Injector.check_captcha.call(captcha_id: params[:captcha_id], captcha_value: params[:captcha_value])[:valid]
      redirect_to("/mod/login?failed=true")
    else
      response.cookies["session"] = JWT.encode({username: user.username, privilege: :admin}, Authentication.secret, JWT::Algorithm::HS256)
      if ENV["AMBER_ENV"] != "development"
        response.cookies["session"].secure = true
      end
      redirect_to("/mod")
    end
  end

  def mod
    unless Injector.authenticate_token.call(token: request.cookies["session"]?)[:valid]
      response.status = :unauthorized
      redirect_to("/mod/login")
    end

    id = params[:id]?
    unless id.nil?
      @post_to_action = id.to_i
    end

    render("mod.ecr")
  end

  def render_login_form
    form(action: "/mod/authenticate", method: "post") do
      csrf_tag() +
      text_field(:username, placeholder: "username") + "<br>"+
      text_field(:password, type: :password, placeholder: "password") +
      CaptchaHelper.captcha_form() +
      submit("login")
    end
  end

  def render_thread(parent : Post | Nil = nil)
  	content(element_name: :div, options: {class: "post"}.to_h) do
  		unless parent.nil?
  		  select_button = content(element_name: :a, content: "Select", options: {
  				href: "/mod/#{parent.id.to_s}#reply-#{parent.id.to_s}",
  				id: "reply-#{parent.id.to_s}"}.to_h) + " " +
  				parent.id.to_s + " " +
  				parent.created_at.to_s
  		else
  			select_button = content(element_name: :a, content: "Deselect", options: {href: "/mod/#top", id: "top"}.to_h)
  		end
  		post_content = content(element_name: :div, options: {class: "post_content"}.to_h) do
  			content(element_name: :p, options: {class: "post_text"}.to_h) do
  				parent.html unless parent.nil?
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
      content(element_name: :details, options: {class: "form"}.to_h) do
        content(element_name: :summary, options: {class: "form_heading"}.to_h) do
          get_mod_form_title()
        end +
        form(action: "/post/delete", method: "delete") do
          csrf_tag() +
          hidden_field(:post_id, value: @post_to_action) +
          submit("delete")
        end
      end
    else
      content(element_name: :details, options: {class: "form"}.to_h) do
        content(element_name: :summary, options: {class: "form_heading"}.to_h) do
          get_mod_form_title()
        end +
        content(element_name: :table, options: {class: "filter_table"}.to_h) do
          content(element_name: :tr, options: {class: "filter_table_row"}.to_h) do
            content(element_name: :th, options: {class: "filter_table_header"}.to_h) do
              "ID"
            end +
            content(element_name: :th, options: {class: "filter_table_header"}.to_h) do
              "Regex"
            end +
            content(element_name: :th, options: {class: "filter_table_header"}.to_h) do
              "Severity"
            end
          end +
          Filter.all.map do |filter|
            content(element_name: :tr, options: {class: "filter_table_row"}.to_h) do
              content(element_name: :td, options: {class: "filter_table_data"}.to_h) do
                filter.id.to_s
              end +
              content(element_name: :td, options: {class: "filter_table_data"}.to_h) do
                filter.regex
              end +
              content(element_name: :td, options: {class: "filter_table_data"}.to_h) do
                filter.severity
              end
            end
          end.join
        end +
        form(action: "/filter/create", method: "post") do
          csrf_tag() +
          text_field(:filter_regex, placeholder: "regex", autocomplete: "off") + "<br/>" +
          text_field(:filter_severity, type: :number, placeholder: "severity", autocomplete: "off") + "<br/>" +
          submit("add filter")
        end+
        form(action: "/filter/delete", method: "delete") do
          csrf_tag() +
          text_field(:filter_id, type: :number, placeholder: "id", autocomplete: "off") + "<br/>" +
          submit("delete filter")
        end
      end
    end
  end
end
