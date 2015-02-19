module CatsHelper
  def localize_date(date)
    I18n.l date, format: :short if date
  end
  def cat_name(cat)
    "#{cat.name} Miuaaa"
  end
  def cat_row_classname(cat)
    cat.followers.count >  5 ? 'celebrety' : 'peasant'
  end
end
