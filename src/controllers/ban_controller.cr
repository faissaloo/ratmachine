class BanController < ApplicationController
  def create
    guard do
      Ban.create(ip_address: params[:ip_address])
      @status_msg = "IP banned"
      @redirect_url = "/mod"
      render("create.ecr")
    end
  end

  def delete
    guard do |token|
      can_delete = params[:ip_address] != request.remote_address
      if can_delete
        Ban.find_by!(ip_address: params[:ip_address]).destroy
        @status_msg = "IP unbanned"
        @redirect_url = "/mod"
        render("delete.ecr")
      else
        @status_msg = "You cannot ban yourself"
        @redirect_url = "/mod"
        render("delete.ecr")
      end
    end
  end
end
