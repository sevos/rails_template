class Current < ActiveSupport::CurrentAttributes
  attribute :locale

  def locale=(locale)
    super(I18n.locale = locale)
  end
end
