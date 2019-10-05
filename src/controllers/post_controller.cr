require "uri"

class PostController < ApplicationController
  def create()
    return render("create.ecr") unless check_captcha && check_message_size && check_filters

    begin
      if params[:parent].empty?
        post_id = Post.reply(params[:msg])
      else
        post_id = Post.reply(params[:msg], params[:parent].to_i)
      end
    rescue Granite::Querying::NotFound
      @status_msg =  "The post you're trying to reply to does not exist"
      return render("create.ecr")
    end

    redirect_to("/#{post_id}#reply-#{post_id}")
    render("create.ecr")
  end

  def delete()
    return render("delete.ecr") unless check_captcha && check_root_password

    post = Post.find(params[:post_id].to_i)
    return render("delete.ecr") unless check_post(post)

    post.as(Post).delete()
    @status_msg = "Post deleted"
    @redirect_url = "/mod"
    render("delete.ecr")
  end

  def render_redirect()
    if params[:msg]?.nil?
      encoded_message = ""
    else
      encoded_message = URI.encode(params[:msg])
    end
    if params[:parent].empty?
      "<meta http-equiv=\"REFRESH\" content=\"1;url=/?msg=#{encoded_message}\">"
    else
      "<meta http-equiv=\"REFRESH\" content=\"1;url=/#{params[:parent]}?msg=#{encoded_message}#reply-#{params[:parent]}\">"
    end
  end

  def check_captcha()
    unless Captcha.is_valid?(params[:captcha_id], params[:captcha_value])
      @status_msg = "Incorrect or expired CAPTCHA"
      return false
    end
    return true
  end

  def check_message_size()
    if params[:msg].empty?
      @status_msg = "Message empty"
      return false
    elsif params[:msg].size > 1024
      @status_msg = "Message too long"
      return false
    end
    return true
  end

  def check_filters()
    severity = Filter.filter_severity(params[:msg])
    unless severity.nil?
      @status_msg = "You just posted cringe, you are going to lose subscribers"
      return false
    end
    return true
  end

  def check_root_password()
    secrets = Amber.settings.secrets
    if secrets.nil?
      @status_msg = "No root password is set"
      return false
    end

    unless params[:password] == secrets["root_password"]
      @status_msg = "Invalid password"
      return false
    end
    return true
  end

  def check_post(post : Post | Nil)
    if post.nil?
      @status_msg = "No such post"
      return false
    end
    return true
  end
end
