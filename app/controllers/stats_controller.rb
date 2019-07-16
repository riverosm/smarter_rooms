class StatsController < ApplicationController
  before_action :set_stats, only: [:top_five, :averages, :rooms_bookings_by_day]

  def rooms_bookings_by_day
    @bookings = @stats.get_rooms_bookings_by_day(params[:room_id])
    if @bookings.count == 5
      render :inline => '<%= column_chart @bookings, suffix: "%", id: "bookings_by_day-chart", xtitle: "Day", ytitle: "Percent of booking by day [%]", max: 100 %>'
    else
      render :inline => '<%= render partial: "not_enough_info" %>'
    end
  end

  def top_five
    @users = @stats.get_five_users_with_more_bookings_from_last_30_days
    @rooms = @stats.get_five_rooms_with_more_bookings_from_last_30_days
  end

  def averages
    @average_bookings = @stats.get_rooms_bookings_by_hour
  end

  private
    def set_stats
      @stats = Stat.new
    end
end