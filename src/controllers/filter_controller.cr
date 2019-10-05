class FilterController < ApplicationController
  def create()
    return render("delete.ecr") unless check_captcha && check_root_password && check_regex_size

    Filter.create(regex: params[:filter_regex], severity: params[:filter_severity].to_i)
    @status_msg = "Filter created"
    @redirect_url = "/mod"
    render("create.ecr")
  end

  def delete()
    return render("delete.ecr") unless check_captcha && check_root_password

    filter = Filter.find(params[:filter_id].to_i)
    return render("delete.ecr") unless check_filter(filter)

    filter.as(Filter).destroy()
    @status_msg = "Filter deleted"
    @redirect_url = "/mod"
    render("delete.ecr")
  end

  def check_captcha()
    unless Captcha.is_valid?(params[:captcha_id], params[:captcha_value])
      @status_msg = "Invalid captcha"
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

  def check_regex_size()
    if params[:filter_regex].size > 1024
      @status_msg = "Regex too long"
      return false
    end
    return true
  end

  def check_filter(filter : Filter | Nil)
    if filter.nil?
      @status_msg = "No such filter"
      return false
    end
    return true
  end
end
