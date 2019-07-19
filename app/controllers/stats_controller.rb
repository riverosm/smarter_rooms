class StatsController < ApplicationController
  before_action :set_stats, only: [:top_five, :averages, :rooms_bookings_by_day, :rooms_bookings_by_hour]

  def rooms_bookings_by_day

    current_week = params[:current_week].to_i

    last_day = DateTime.yesterday
    if current_week > -5 && current_week < 0
        last_day = DateTime.now+(8*current_week).days
    end

    date_start = last_day.end_of_day-7.days
    date_end = last_day.end_of_day

    @date_from = date_start.strftime("%d/%m/%Y")
    @date_to = date_end.strftime("%d/%m/%Y")

    @bookings = @stats.get_rooms_bookings_by_day(params[:room_id], date_start, date_end)
    if @bookings.count > 0
      render :inline => '<%= column_chart @bookings, suffix: "%", id: "bookings_by_day-chart", xtitle: "Day - Only weekdays from " + @date_from + " to " + @date_to, ytitle: "Percent of bookings by day [%]", max: 100 %>'
    else
      render :inline => '<%= render partial: "not_enough_info" %>'
    end
  end

  def rooms_bookings_by_hour
    days_count = params[:days_count].to_i

    hours_per_day = Rails.configuration.smarter_rooms_calendar_end_time - Rails.configuration.smarter_rooms_calendar_start_time

    date_start = (DateTime.yesterday.end_of_day-days_count.days).beginning_of_day
    date_end = DateTime.yesterday.end_of_day

    # get the REAL min, max and days_count <- if there is not enough data will be different to date_start and date_end
    real_date_start = Booking.where(valid_from: date_start..date_end).minimum(:valid_from).beginning_of_day
    real_date_end = Booking.where(valid_from: date_start..date_end).maximum(:valid_from).end_of_day
    real_days_count = (real_date_end.to_date - real_date_start.to_date).to_i

    @date_from = real_date_start.strftime("%d/%m/%Y")
    @date_to = real_date_end.strftime("%d/%m/%Y")

    @bookings = @stats.get_rooms_bookings_by_hour(real_days_count,real_date_start,real_date_end)
    if @bookings.count > 0
      render :inline => '<%= column_chart @bookings, id: "bookings_by_hour-chart" , xtitle: "Hour (Information from " + @date_from + " to " + @date_to + ")", ytitle: "Average booking count of the last ' + params[:days_count].to_s + ' days"%>'
    else
      render :inline => '<%= render partial: "not_enough_info" %>'
    end
  end

  def top_five
    @users = @stats.get_five_users_with_more_bookings_from_last_30_days
    @rooms = @stats.get_five_rooms_with_more_bookings_from_last_30_days
  end

  def averages
  end

  private
    def set_stats
      @stats = Stat.new
    end
end