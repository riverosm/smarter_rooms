class Stat < ApplicationController
  def get_five_users_with_more_bookings_from_last_30_days
    Booking.last_30_days.group(:user).order(:count).limit(5).count.map { |u| [u[0].name, u[1]] }.sort_by { |k| -k[1] }
  end

  def get_five_rooms_with_more_bookings_from_last_30_days
    Booking.last_30_days.group(:room).order(:count).limit(5).count.map { |u| [u[0].name, u[1]] }.sort_by { |k| -k[1] }
  end

  def get_rooms_bookings_by_hour
    #Booking.where(valid_from: DateTime.yesterday.end_of_day-7.days..DateTime.yesterday.end_of_day).group('strftime("%H", valid_from)').count.map {|a| a[1]/(hours_per_day*7).to_f}
    hours_per_day = Rails.configuration.smarter_rooms_calendar_end_time - Rails.configuration.smarter_rooms_calendar_start_time
    days_count = 5
    range_filter = Booking.where(valid_from: DateTime.yesterday.end_of_day-7.days..DateTime.yesterday.end_of_day)
    range_filter.group('strftime("%H", valid_from)').count.map {|a| [a[0],(a[1]/(hours_per_day*days_count).to_f).round(2)]}
  end

  def get_rooms_bookings_by_day(room_id, current_week)
    # For all rooms and comparisions
    # Booking.where(room_id: ' + params[:room_id] + ').joins(:room).group("rooms.name", "strftime(\"%d/%m/%Y\", valid_from)").order(:valid_from).count
    last_day = DateTime.yesterday
    if current_week > -5 && current_week < 0
        last_day = DateTime.now+(8*current_week).days
    end

    date_start = last_day.end_of_day-7.days
    date_end = last_day.end_of_day

    room_filter = Booking.where(room: room_id)
    range_filter = room_filter.where(valid_from: last_day.end_of_day-7.days..last_day.end_of_day)
    @rooms_bookings_by_day = range_filter.group('DATE(valid_from)').sum('round((strftime("%H:%m", valid_to) - strftime("%H:%m", valid_from) / 9),2)')

    while(date_start < date_end) do
      # Check if not weekend
      date_start += 1.day
      if !date_start.on_weekend?
        if !@rooms_bookings_by_day.key?(date_start.to_date.to_s)
          @rooms_bookings_by_day[date_start.to_date.to_s] = 0
        end
      end
    end

    @rooms_bookings_by_day.sort.map {|rb| [rb[0].to_date.strftime("%a %d/%m"),rb[1]]}
  end
end