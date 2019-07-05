class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :create]

  def index
  end

  def show
  end

  def new
    @booking = generate_new_booking
  end

  def create
  end

  private
  def set_room
    @room = Room.where("active = 1 AND id = ?",params[:room_id]).first
    if @room.nil?
      flash[:danger] = "You are not allowed to access this room."
      redirect_to rooms_url
    end

    @room_booked = current_user.bookings.active.any?{|br| br.room == @room}
  end

  def generate_new_booking
    booking = Booking.new
    booking.valid_from = Time.now
    booking.valid_to = booking.valid_from + 2.days
    booking
  end
end
