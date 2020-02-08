class FilterController < ApplicationController
  def create()
    guard do
      Filter.create(regex: params[:filter_regex], severity: params[:filter_severity].to_i)
      @status_msg = "Filter created"
      @redirect_url = "/mod"
      render("create.ecr")
    end
  end

  def delete()
    guard do
      filter = Filter.find(params[:filter_id].to_i)
      return render("delete.ecr") unless check_filter(filter)

      filter.as(Filter).destroy()
      @status_msg = "Filter deleted"
      @redirect_url = "/mod"
      render("delete.ecr")
    end
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
