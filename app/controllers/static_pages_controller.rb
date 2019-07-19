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
    end
  end

  def about
  end
end