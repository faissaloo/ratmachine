class ThemeController < ApplicationController
  def set
    name = params[:name]
    response.cookies["theme_name"] = name
    @status_msg = "Theme set to #{name}"
    @redirect_url = "/"
    render("set.ecr")
  end
end
