class IndexController < ApplicationController
  @error_msg : String | Nil
  @heading_image : String | Nil
  @reply_to : Int32 | Nil
  def index
    @error_msg = ""
    @heading_image = ""
    id = params[:id]?
    unless id.nil?
      @reply_to = id.to_i
    end
    #@heading_image = Dir.glob("#{Rails.root}/app/assets/images/heading/*").sample.split("#{Rails.root}/app/assets/images/")[1] #Dir.glob("*")
    render("index.ecr")
  end

  def post
    unless Captcha.is_valid?(params[:captcha_id], params[:captcha_value])
      return "Incorrect or expired CAPTCHA"
    end

    #Might wanna rescue in the case that we try to reply to something that
    # doesn't exist but idk how
    if params[:parent].empty?
      post_id = Post.reply(params[:msg])
    else
      post_id = Post.reply(params[:msg], params[:parent].to_i)
    end

    redirect_to("/#{post_id}#reply-#{post_id}")

    render("post.ecr")
  end

  #View helpers, should probably be moved
  def render_thread(parent : Post | Nil = nil)
  	content(element_name: :div, options: {class: "post"}.to_h) do
  		unless parent.nil?
  			post_button = content(element_name: :a, content: "Reply", options: {
  				href: "#{parent.id.to_s}#reply-#{parent.id.to_s}",
  				id: "reply-#{parent.id.to_s}"}.to_h) +
  				parent.id.to_s +
  				parent.created_at.to_s #("%d/%m/%Y %H:%M")
  		else
  			post_button = content(element_name: :a, content: "Post", options: {href: "/#top", id: "top"}.to_h)
  		end
  		post_content = content(element_name: :div, options: {class: "post_content"}.to_h) do
  			content(element_name: :p, options: {class: "post_text"}.to_h) do
  				parent.html unless parent.nil? #.html_safe
  			end
  		end

  		child_posts = Post.get_replies(parent).map do |post|
  			render_thread(post).as(String)
  		end.join("<br/>")
  		post_button + "<br/>" + post_content + child_posts
  	end
  end

  def render_banner()
    content(element_name: :div, options: {class: "banner"}.to_h) do
    	content(element_name: :img, content: "a random apng", options: {src: @heading_image.to_s, id: "heading_image"}.to_h) +
    	content(element_name: :h2, options: {id: "motd"}.to_h) do
    		#FormatterHelper.heading.html_safe
    	end +
    	content(element_name: :h4, options: {id: "bitcoin"}.to_h) do
    		"Bitcoin: 1LseDRH9dywzfpW6vGpkaNYpQWSpaqwz44"
    	end +
    	content(element_name: :div, options: {id: "about_opener"}.to_h) do
    		content(element_name: :a, options: {id: "about_button"}.to_h) do
    			"About"
    		end +
    		content(element_name: :p, options: {id: "about"}.to_h) do
    			content(element_name: :a, content: "Ratwires", options: {href: "https://github.com/faissaloo/Ratmachine"}.to_h) +
            "is an anonymous AGPL'd javascriptless single board textboard inspired by" +
            content(element_name: :a, content: "Make Frontend Shit Again", options: {href: "https://makefrontendshitagain.party/"}.to_h) +
            " and " +
            content(element_name: :a, content: "2channel", options: {href: "https://5ch.net/"}.to_h) +
            "written in Crystal with the Amber Framework. It has a 255 post limit, after which the oldest post will be purged."
    		end
    	end
    end
  end

  def render_post_form()
    content(element_name: :div, options: {class: "post_form"}.to_h) do
      #reply_msg = "Posting"
      #reply_msg = "Replying to post #{@reply_to}" unless @reply_to.nil?
      #We can't mark this as post_form_contents because options: doesn't work
  		form(action: "", method: "post") do
        csrf_tag() +
        hidden_field(:parent, value: @reply_to) + "<br/>" +
        label(:msg, "Message:") + "<br/>" +
        captcha_form() +
        #Also can't add autofocus to this because again, no options
  			text_area(:msg, "") + "<br/>" +
  			submit("post")
  		end

  		#reply_msg + post_form
  	end
  end


  def captcha_form()
    new_captcha = Captcha.generate()
    content(element_name: :div, options: {class: "captcha_form"}.to_h) do
      content(element_name: :img, content: "CAPTCHA", options: {src: "/dist/images/captcha/#{new_captcha.id.to_s}.png"}.to_h) + "<br/>" +
      hidden_field(:captcha_id, value: new_captcha.id) + "<br/>" +
      text_field(:captcha_value) + "<br/>"
    end
  end
end
