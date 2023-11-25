module ApplicationHelper
    ActionView::Base.default_form_builder = ApplicationFormBuilder
  
    def current_url
      request.url
    end
  end
  