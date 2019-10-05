require "../helpers/captcha/captcha"

class IndexController < ApplicationController
  @status_msg : String | Nil
  @heading_image : String | Nil
  @reply_to : Int32 | Nil
  def index
    @status_msg = ""
    @heading_image = ""
    id = params[:id]?
    unless id.nil?
      @reply_to = id.to_i
    end
    render("index.ecr")
  end

  def is_selected_class(post : Post | Nil)
    if (@reply_to.nil? && post.nil?) || ((!post.nil?) && @reply_to == post.id)
      " SelectedPost"
    else
      ""
    end
  end

  def render_thread(parent : Post | Nil = nil)
  	content(element_name: :div, options: {class: "post"+is_selected_class(parent)}.to_h) do
  		unless parent.nil?
  			post_button = content(element_name: :a, content: "Reply", options: {
  				href: "#{parent.id.to_s}#reply-#{parent.id.to_s}",
  				id: "reply-#{parent.id.to_s}"}.to_h) + " " +
  				parent.id.to_s + " " +
  				parent.created_at.to_s
  		else
  			post_button = content(element_name: :a, content: "Post", options: {href: "/#top", id: "top"}.to_h)
  		end
  		post_content = content(element_name: :div, options: {class: "post_content"}.to_h) do
  			content(element_name: :p, options: {class: "post_text"}.to_h) do
  				parent.html unless parent.nil?
  			end
  		end

  		child_posts = Post.get_replies(parent).map do |post|
  			render_thread(post).as(String)
  		end.join("<br/>")
  		post_button + "<br/>" + post_content + child_posts
  	end
  end

  def get_post_form_title()
    return "Posting <br/>" if @reply_to.nil?
    "Replying to post #{@reply_to} <br/>"
  end

  def render_post_form()
    content(element_name: :summary, options: {class: "form_heading"}.to_h) do
      get_post_form_title()
    end +
    content(element_name: :div, options: {class: "form_contents"}.to_h) do
  		form(action: "/post/create/#{@reply_to}", method: "post") do
        csrf_tag() +
        hidden_field(:parent, value: @reply_to) + "<br/>" +
        label(:msg, "Message:") + "<br/>" +
  			text_area(:msg, params[:msg]?, autofocus: "true") + "<br/>" +
        CaptchaHelper.captcha_form() +
  			submit("post")
  		end
    end
  end

  def render_post_container()
    if params[:msg]?.nil?
      content(element_name: :details, options: {class: "form"}.to_h) do
        render_post_form()
      end
    else
      content(element_name: :details, options: {class: "form", open: true}.to_h) do
        render_post_form()
      end
    end
  end
end
