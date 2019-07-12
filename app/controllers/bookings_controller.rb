class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :create]

  def index
    @bookings_today = Booking.where(valid_to: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
    @bookings_lasts = Booking.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).order("created_at DESC")
  end

  def show
  end

  def new
  end

  def create
    byebug
    @booking = Booking.new

    @booking.valid_from = params["booking"]["valid_from_full"].to_datetime
    @booking.valid_to = params["booking"]["valid_to_full"].to_datetime
    @booking.number_of_attendants = booking_params[:number_of_attendants]
    @booking.room = @room
    @booking.user = current_user

    if @booking.save
      flash[:success] = "You have successfully booked #{@room.name}"
      redirect_to rooms_path
    else
      flash[:danger] = "There was errors perfmorming the operation: <br> #{@booking.errors.first.last}"
      redirect_to new_booking_path(room_id: @room.id)
    end
  end

  private
  def set_room
    @room = Room.where("active = 1 AND id = ?",params[:room_id]).first
    if @room.nil?
      flash[:danger] = "You are not allowed to access this room."
      redirect_to rooms_url
    end
  end

  def booking_params
    params.require(:booking).permit(:valid_from_full, :valid_to_full, :number_of_attendants, :room_id)
  end
end
