class PostController < ApplicationController
  def delete
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
    render("delete.ecr")
  end
end
