module ApplicationHelper
  def date_time_string_to_datetime(date, time)
    if date.class != DateTime
      date = Date.parse date
    end
    time_hour = time.split(":")[0].to_i
    time_minutes = time.split(":")[1].to_i

    datetime = DateTime.new(date.year, date.month, date.day, time_hour, time_minutes, 0, "-0300")
    if datetime.class != DateTime
      nil
    else
      datetime
    end
  end
end
