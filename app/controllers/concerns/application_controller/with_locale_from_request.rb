module ApplicationController::WithLocaleFromRequest
    extend ActiveSupport::Concern
  
    included do |controller|
      before_action :set_locale
    end
  
    private
  
    def set_locale
      requested_locales = request.headers['HTTP_ACCEPT_LANGUAGE']
  
      if requested_locales
        # Split the requested languages by comma
        requested_locales = requested_locales.split(',')
  
        # Iterate through the requested locales until you find a matching one
        requested_locales.each do |requested_locale|
          # Split the requested locale by underscore and extract the first part
          requested_locale = requested_locale.split('-').first
          # Check if the requested locale is available in the available locales
          if I18n.available_locales.include?(requested_locale.to_sym)
            Current.locale = requested_locale.to_sym
            return
          end
        end
      end
  
      # If no matching locale was found, set default
      Current.locale = I18n.default_locale
    end
  end