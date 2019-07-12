class Stat < ApplicationController
  def get_five_users_with_more_bookings_from_last_30_days
    Booking.last_30_days.group(:user).order(:count).limit(5).count.map { |u| [u[0].name, u[1]] }.sort_by { |k| -k[1] }
  end

  def get_five_rooms_with_more_bookings_from_last_30_days
    Booking.last_30_days.group(:room).order(:count).limit(5).count.map { |u| [u[0].name, u[1]] }.sort_by { |k| -k[1] }
  end

  def stats_tests
    Booking.group(:room_id, 'strftime("%d/%m/%Y", valid_from)').count

    Booking.group(:room_id).sum('strftime("%H:%m", valid_to) - strftime("%H:%m", valid_from)')
  end
end