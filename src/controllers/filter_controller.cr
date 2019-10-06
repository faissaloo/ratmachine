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
    filter_check = Injector.check_captcha.call(captcha_id: params[:captcha_id], captcha_value: params[:captcha_value])
    @status_msg = filter_check[:status]
    filter_check[:valid]
  end

  def check_root_password()
    filter_check = Injector.check_root_password.call(password: params[:password])
    @status_msg = filter_check[:status]
    filter_check[:valid]
  end

  def check_regex_size()
    filter_check = Injector.check_regex_size.call(regex: params[:filter_regex])
    @status_msg = filter_check[:status]
    filter_check[:valid]
  end

  def check_filter(filter : Filter | Nil)
    if filter.nil?
      @status_msg = "No such filter"
      return false
    end
    return true
  end
end
