class UserController < ApplicationController
  def create
    guard do
      User.create(username: params[:username], salted_hashed_password: Crypto::Bcrypt::Password.create(params[:password]).to_s)
      @status_msg = "User created"
      @redirect_url = "/mod"
      render("create.ecr")
    end
  end

  def delete
    guard do |token|
      can_delete = params[:username] != token[:username]
      if can_delete
        User.find_by!(username: params[:username]).destroy
        @status_msg = "User deleted"
        @redirect_url = "/mod"
        render("delete.ecr")
      else
        @status_msg = "You cannot Delete Yourself!"
        @redirect_url = "/mod"
        render("delete.ecr")
      end
    end
  end
end
