require "uri"

class PostController < ApplicationController
  def create()
    unless Captcha.is_valid?(params[:captcha_id], params[:captcha_value])
      @error_msg = "Incorrect or expired CAPTCHA"
      return render("create.ecr")
    end
    if params[:msg].empty?
      @error_msg = "Message empty"
      return render("create.ecr")
    elsif params[:msg].size > 1024
      @error_msg = "Message too long"
      return render("create.ecr")
    end

    begin
      if params[:parent].empty?
        post_id = Post.reply(params[:msg])
      else
        post_id = Post.reply(params[:msg], params[:parent].to_i)
      end
    rescue Granite::Querying::NotFound
      @error_msg =  "The post you're trying to reply to does not exist"
      return render("create.ecr")
    end

    redirect_to("/#{post_id}#reply-#{post_id}")
    render("create.ecr")
  end

  def delete()
    unless Captcha.is_valid?(params[:captcha_id], params[:captcha_value])
      @status_msg = "Invalid captcha"
      return render("delete.ecr")
    end
    secrets = Amber.settings.secrets
    if secrets.nil?
      @status_msg = "No root password is set"
      return render("delete.ecr")
    end

    unless params[:password] == secrets["root_password"]
      @status_msg = "Invalid password"
      return render("delete.ecr")
    end
    post = Post.find(params[:post_id].to_i)
    if post.nil?
      @status_msg = "No such post"
      return render("delete.ecr")
    end

    post.delete()
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
end
