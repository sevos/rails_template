module ApplicationController::Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?
  end

  protected

    def current_user
      Current.user ||= authenticate_user_from_session || authenticate_user_from_cookies
    end

    def signed_in?
      current_user.present?
    end

    def authenticate_user_from_session
      User.find_by(id: session[:user_id])
    end

    def authenticate_user_from_cookies
      Rails.logger.warn cookies.signed.inspect

      if user_id = cookies.signed[:user_id]
        User.find_by(id: user_id)
      end
    end

    def sign_in(user, remember_me: false)
      Current.user = user
      reset_session
      session[:user_id] = user.id

      if remember_me
        cookies.permanent.signed[:user_id] = user.id
      end
    end

    def sign_out
      Current.user = nil
      cookies.delete(:user_id)
      reset_session
    end
end
