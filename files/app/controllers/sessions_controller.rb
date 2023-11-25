class SessionsController < ApplicationController
  layout 'site'

  def new
    @user = User.new
  end

  def create
    user = User.authenticate_by(email: params[:user][:email], password: params[:user][:password])

    if user
      sign_in(user, remember_me: remember_me?)
      redirect_to root_path
    else
      @user = User.new(email: params[:user][:email])
      flash.now[:error] = "Invalid email or password"
      render :new, status: :unauthorized
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

    def remember_me?
      params[:remember_me] == '1'
    end
end
