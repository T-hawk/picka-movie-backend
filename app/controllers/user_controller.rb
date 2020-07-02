class UserController < ApplicationController

  def index
    user = User.find(params[:user_id])

    if user
      render json: { user: user }
    else
      render json: { status: 401 }
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      token = helpers.gen_token
      user.token = token
      user.save
      render json: { user: user }
    end
  end

  def login
    user = User.find_by(email: user_params["email"]).try(:authenticate, user_params["password"])

    if user
      token = helpers.gen_token
      user.token = token
      user.save
      render json: {
        user: user
      }
    else
      render json: { status: 401 }
    end
  end

  def user_params
    params.require("user").permit("name", "email", "password", "password_confirmation")
  end
end
