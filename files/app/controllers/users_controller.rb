class UsersController < ApplicationController
  layout 'site', only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      sign_in @user, remember_me: true
      redirect_to tasklists_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
