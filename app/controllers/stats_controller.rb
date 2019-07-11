class StatsController < ApplicationController
  def home
    stats = Stat.new
    @users = stats.get_five_users_with_more_bookings_from_last_30_days
    @rooms = stats.get_five_rooms_with_more_bookings_from_last_30_days
  end
end