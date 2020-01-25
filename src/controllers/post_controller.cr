require "uri"

class PostController < ApplicationController
  @status_msg : String | Nil

  def create()
    return render("create.ecr") unless check_captcha && check_message_size && check_filters

    post = Injector.create_post.call(message: params[:msg], parent: params[:parent].to_i32?)
    @status_msg = post[:status]

    if post[:post_id].nil?
      render("create.ecr")
    else
      redirect_to("/#{post[:post_id]}#reply-#{post[:post_id]}")
    end
  end

  def delete()
    guard do
      @status_msg = Injector.delete_post.call(params[:post_id].to_i)[:status]
      @redirect_url = "/mod"
      render("delete.ecr")
    end
  end
  
  def check_captcha()
    filter_check = Injector.check_captcha.call(captcha_id: params[:captcha_id], captcha_value: params[:captcha_value])
    @status_msg = filter_check[:status]
    filter_check[:valid]
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
end
