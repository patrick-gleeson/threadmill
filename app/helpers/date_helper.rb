module DateHelper
  def format_date(date)
    date.strftime('%A, %d %b %Y')
  end
end
