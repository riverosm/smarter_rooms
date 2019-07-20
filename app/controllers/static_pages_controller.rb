class StaticPagesController < ApplicationController
  def home
    if !logged_in?
      redirect_to login_path
    elsif current_user.is_admin?
      @cant_admin = User.is_admin.count
      @cant_users = User.is_user.count
      @total_users = @cant_admin + @cant_users

      @cant_buildings = Building.count
      @rooms_per_building = Room.active.joins(:building).group("buildings.name").count

      @cant_rooms_active = Room.active.count
      @cant_rooms_inactive = Room.inactive.count
      @total_rooms = @cant_rooms_active + @cant_rooms_inactive

      @cant_bookings_past = Booking.where("valid_from < ?", DateTime.now).count
      @cant_bookings_next = Booking.where("valid_from > ?", DateTime.now).count
      @total_bookings = @cant_bookings_past + @cant_bookings_next
    else
      max_results = 5

      @bookings_today = current_user.bookings.where(valid_from: DateTime.now..DateTime.now.end_of_day).order("valid_from, valid_to").limit(max_results)
      @bookings_lasts = current_user.bookings.where("valid_from < ?", DateTime.now).order("valid_from DESC, valid_to DESC").limit(max_results)
      @bookings_nexts = current_user.bookings.where("valid_from > ?", DateTime.tomorrow.beginning_of_day).order("valid_from, valid_to").limit(max_results)
      @most_booked_rooms = current_user.rooms.group("rooms.id").order("count_all DESC").limit(max_results).count
    end
  end

  def about
  end
end