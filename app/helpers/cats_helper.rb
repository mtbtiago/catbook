module CatsHelper
  def localize_date(date)
    I18n.l date, format: :long if date
  end
end
