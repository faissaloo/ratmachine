require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  LAYOUT = "application.ecr"

  @redirect_url : String | Nil
  def redirector()
    "<meta http-equiv=\"REFRESH\" content=\"1;url=#{@redirect_url}\">" unless @redirect_url.nil?
  end

  def render_banner()
    heading_image = Dir.glob("public/dist/images/banners/*").sample.sub("public/","")
    content(element_name: :div, options: {class: "banner"}.to_h) do
      content(element_name: :img, content: "", options: {src: heading_image.to_s, id: "heading_image", alt: "XD lol random dancing"}.to_h) +
      content(element_name: :h4, options: {id: "main info"}.to_h) do
        "Bitcoin: 1LseDRH9dywzfpW6vGpkaNYpQWSpaqwz44 " +
        content(element_name: :a, content: "TOR", options: {href: "http://clo5p5jsvei55iyz.onion"}.to_h)
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
end
