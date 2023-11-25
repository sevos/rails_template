class BaseController < ApplicationController
  include Tenancy

  before_action :require_login

  private

  def require_login
    redirect_to new_session_path unless signed_in?
  end
end
