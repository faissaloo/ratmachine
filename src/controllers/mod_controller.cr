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
      if ENV["AMBER_ENV"] == "production"
        response.cookies["session"].secure = true
      end
      redirect_to("/mod")
    end
  end

  def mod
    guard do
      id = params[:id]?
      unless id.nil?
        @post_to_action = id.to_i
      end

      render("mod.ecr")
    end
  end

  def delete
    guard do
      render("delete.ecr")
    end
  end

  def filter
    guard do
      render("filter.ecr")
    end
  end

  def user
    guard do
      render("user.ecr")
    end
  end

  def ban
    guard do
      render("ban.ecr")
    end
  end

  def render_ban_form
    content(element_name: :div, options: {class: "panel"}.to_h) do
      content(element_name: :table, options: {class: "ban_table"}.to_h) do
        content(element_name: :tr, options: {class: "ban_table_row"}.to_h) do
          content(element_name: :th, options: {class: "ban_table_header"}.to_h) do
            "ID"
          end +
          content(element_name: :th, options: {class: "ban_table_header"}.to_h) do
            "IP address"
          end
        end +
        Ban.all.map do |ban|
          content(element_name: :tr, options: {class: "ban_table_row"}.to_h) do
            content(element_name: :td, options: {class: "ban_table_data"}.to_h) do
              ban.id.to_s
            end +
            content(element_name: :td, options: {class: "ban_table_data"}.to_h) do
              ban.ip_address
            end
          end
        end.join
      end +
      form(action: "/ban/delete", method: "delete") do
        csrf_tag() +
        text_field(:ip_address, placeholder: "ip address", value: params[:ip]?) +
        submit("delete")
      end +
      form(action: "/ban/create", method: "post") do
        csrf_tag() +
        text_field(:ip_address, placeholder: "ip address", value: params[:ip]?) +
        submit("create")
      end
    end
  end

  def render_user_form
    content(element_name: :div, options: {class: "panel"}.to_h) do
      content(element_name: :table, options: {class: "user_table"}.to_h) do
        content(element_name: :tr, options: {class: "user_table_row"}.to_h) do
          content(element_name: :th, options: {class: "user_table_header"}.to_h) do
            "ID"
          end +
          content(element_name: :th, options: {class: "user_table_header"}.to_h) do
            "Username"
          end
        end +
        User.all.map do |user|
          content(element_name: :tr, options: {class: "user_table_row"}.to_h) do
            content(element_name: :td, options: {class: "user_table_data"}.to_h) do
              user.id.to_s
            end +
            content(element_name: :td, options: {class: "user_table_data"}.to_h) do
              user.username
            end
          end
        end.join
      end +
      form(action: "/user/delete", method: "delete") do
        csrf_tag() +
        text_field(:username, placeholder: "username") +
        submit("delete")
      end +
      form(action: "/user/create", method: "post") do
        csrf_tag() +
        text_field(:username, placeholder: "username") +
        text_field(:password, type: :password, placeholder: "password") +
        submit("create")
      end
    end
  end

  def render_login_form
    content(element_name: :div, options: { class: "panel" }.to_h) do
      form(action: "/mod/authenticate", method: "post") do
        csrf_tag() +
        text_field(:username, placeholder: "username") + "<br>"+
        text_field(:password, type: :password, placeholder: "password") +
        CaptchaHelper.captcha_form() +
        submit("login")
      end
    end
  end

  def render_panel()
    content(element_name: :div, options: { class: "panel" }.to_h) do
      content(element_name: :a, options: { href: "/mod/delete?id=#{ params[:id]? }&ip=#{ params[:ip]? }" }.to_h) do
        "Delete posts"
      end +
      "<br/>" +
      content(element_name: :a, options: { href: "/mod/filter?id=#{ params[:id]? }&ip=#{ params[:ip]? }" }.to_h) do
        "Manage post filters"
      end +
      "<br/>"+
      content(element_name: :a, options: { href: "/mod/ban?id=#{ params[:id]? }&ip=#{ params[:ip]? }" }.to_h) do
        "Manage bans"
      end +
      "<br/>"+
      content(element_name: :a, options: { href: "/mod/user?id=#{ params[:id]? }&ip=#{ params[:ip]? }" }.to_h) do
        "Manage admin users"
      end
    end
  end

  def render_delete_form()
    content(element_name: :div, options: {class: "panel"}.to_h) do
      form(action: "/post/delete", method: "delete") do
        csrf_tag() +
        text_field(:post_id, type: :number, value: params[:id]?) +
        submit("delete")
      end
    end
  end

  def render_filter_form()
    content(element_name: :div, options: {class: "panel"}.to_h) do
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
