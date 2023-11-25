module ApplicationHelper
  ActionView::Base.default_form_builder = ApplicationFormBuilder

  def current_url
    request.url
  end

  def title(text, subtitle = nil)
    if turbo_native_app?
      content_for(:title, text)
    else
      content_for(:title, [text, t('habtrack')].compact.join(' | '))
    end

    content_tag :div, class: 'py-2' do
      safe_join [
        content_tag(:h1, class: 'turbo-native:hidden text-center font-bold text-lg') do
          text
        end,
        subtitle.present? ? content_tag(:p, class: 'text-center text-xs text-gray-300') do
          subtitle
        end : nil
      ]
    end
  end
  end
