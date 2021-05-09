require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  LAYOUT = "application.ecr"

  @redirect_url : String | Nil
  def redirector()
    "<meta http-equiv=\"REFRESH\" content=\"1;url=#{@redirect_url}\">" unless @redirect_url.nil?
  end

  def render_banner()
    content(element_name: :div, options: {class: "banner"}.to_h) do
      content(element_name: :h4, options: {id: "main info"}.to_h) do
        "Bitcoin: 1LseDRH9dywzfpW6vGpkaNYpQWSpaqwz44 " +
        content(element_name: :a, content: "TOR", options: {href: "http://6bjckqi7h3cm2bfseh63ukg5ptr77czwm53cfqv7gjwcm6bmvehaaeqd.onion/"}.to_h)
      end +
      content(element_name: :details, options: {id: "about_opener"}.to_h) do
        content(element_name: :summary, options: {id: "about_button"}.to_h) do
          "About"
        end +
        content(element_name: :p, options: {id: "about"}.to_h) do
          content(element_name: :a, content: "Ratwires", options: {href: "https://github.com/faissaloo/Ratmachine"}.to_h) +
            " is an anonymous AGPL'd javascriptless single board textboard inspired by " +
            content(element_name: :a, content: "Make Frontend Shit Again", options: {href: "https://makefrontendshitagain.party/"}.to_h) +
            " and " +
            content(element_name: :a, content: "2channel", options: {href: "https://5ch.net/"}.to_h) +
            " written in " +
            content(element_name: :a, content: "Crystal", options: {href: "https://crystal-lang.org"}.to_h) +
            " with the " +
            content(element_name: :a, content: "Amber Framework", options: {href: "https://github.com/amberframework/amber"}.to_h) +
            ". It has a 255 post limit, after which the post that has been on the top level the longest is purged."
        end
      end
    end
  end

  def guard(&block)
    token = authenticate_token

    unless token[:valid]
      response.status = :unauthorized
      redirect_to("/mod/login")
    end
    yield token
  end

  def authenticate_token
    Injector.authenticate_token.call(token: request.cookies["session"]?)
  end
end
