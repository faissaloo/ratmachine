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
    filter_check = Injector.check_captcha.call(captcha_id: params[:captcha_id], captcha_value: params[:captcha_value])
    @status_msg = filter_check[:status]
    filter_check[:valid]
  end

  def check_message_size()
    filter_check = Injector.check_message_size.call(message: params[:msg])
    @status_msg = filter_check[:status]
    filter_check[:valid]
  end

  def check_filters()
    filter_check = Injector.check_filters.call(message: params[:msg])
    @status_msg = filter_check[:status]
    filter_check[:valid]
  end

  def check_root_password()
    filter_check = Injector.check_root_password.call(password: params[:password])
    @status_msg = filter_check[:status]
    filter_check[:valid]
  end

  def check_post(post : Post | Nil)
    if post.nil?
      @status_msg = "No such post"
      return false
    end
    return true
  end
end
