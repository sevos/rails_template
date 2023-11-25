class ApplicationController < ActionController::Base
    include WithLocaleFromRequest
    include Authentication

    around_action :wrap_in_transaction

    helper_method :turbo_native_app?

    def wrap_in_transaction
      ActiveRecord::Base.transaction do
        yield
      end
    end
  end
