class Current < ActiveSupport::CurrentAttributes
  attribute :locale, :user

  def locale=(locale)
    super(I18n.locale = locale)
  end
end
