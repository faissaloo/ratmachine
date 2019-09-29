class FilterController < ApplicationController
  def create()
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

    if params[:filter_regex].size > 1024
      @status_msg = "Regex too long"
      return render("delete.ecr")
    end

    Filter.create(regex: params[:filter_regex], severity: params[:filter_severity].to_i)
    @status_msg = "Filter created"
    @redirect_url = "/mod"
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

    filter = Filter.find(params[:filter_id].to_i)
    if filter.nil?
      @status_msg = "No such filter"
      return render("delete.ecr")
    end

    filter.destroy()
    @status_msg = "Filter deleted"
    @redirect_url = "/mod"
    render("delete.ecr")
  end
end
