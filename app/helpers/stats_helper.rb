module StatsHelper
  
  def short_format_date(date)
    date.strftime("%b %d, %y")
  end

  def format_average_reviews(avg)
    sprintf("%0.1f",avg)
  end
  

end
