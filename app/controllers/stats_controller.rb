class StatsController < ApplicationController
  before_action :set_stats, only: [:top_five, :averages, :rooms_bookings_by_day, :rooms_bookings_by_hour]

  def rooms_bookings_by_day
    @bookings = @stats.get_rooms_bookings_by_day(params[:room_id], params[:current_week].to_i)
    if @bookings.count > 0
      render :inline => '<%= column_chart @bookings, suffix: "%", id: "bookings_by_day-chart", xtitle: "Day", ytitle: "Percent of bookings by day [%]", max: 100 %>'
    else
      render :inline => '<%= render partial: "not_enough_info" %>'
    end
  end

  def rooms_bookings_by_hour
    @bookings = @stats.get_rooms_bookings_by_hour(params[:days_count].to_i)
    if @bookings.count > 0
      render :inline => '<%= column_chart @bookings, id: "bookings_by_hour-chart" , xtitle: "Hour", ytitle: "Average booking of the last ' + params[:days_count].to_s + ' days"%>'
    else
      render :inline => '<%= render partial: "not_enough_info" %>'
    end
  end

  def top_five
    @users = @stats.get_five_users_with_more_bookings_from_last_30_days
    @rooms = @stats.get_five_rooms_with_more_bookings_from_last_30_days
  end

  def averages
    @average_bookings = @stats.get_rooms_bookings_by_hour(30)
  end

  private
    def set_stats
      @stats = Stat.new
    end
end