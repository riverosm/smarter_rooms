class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :create]

  def index
  end

  def show
  end

  def new
    @booking = generate_new_booking
    @buildings = Building.all.sort_by{|b| b.name}
    one_time = Hash.new
    @times_from = @room.get_available_times
    @times_to = @times_from
  end

  def create
    @booking = Booking.new
    @booking.valid_from = date_time_string_to_datetime(booking_params[:valid_from_date], booking_params[:valid_from_time])
    @booking.valid_to = date_time_string_to_datetime(booking_params[:valid_from_date], booking_params[:valid_to_time])
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

  def generate_new_booking
    booking = Booking.new
    booking.valid_from = Time.now
    booking.valid_to = booking.valid_from + 2.days
    booking
  end

  def booking_params
    params.require(:booking).permit(:valid_from_date, :valid_from_time, :valid_to_time, :number_of_attendants, :room_id)
  end
end
