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
    if @room_booked
      flash[:danger] = "You already have an active book for #{@room.name}"
      redirect_to rooms_path
    else
      @booking = Booking.new
      @booking.valid_from = booking_params[:valid_from_date]
      @booking.valid_to = 2.days.from_now.to_date
      @booking.number_of_attendants = booking_params[:number_of_attendants]
      @booking.room = @room
      @booking.user = current_user

      if @booking.save
        flash[:success] = "You have successfully booked #{@room.name}"
        redirect_to rooms_path
      else
        flash[:danger] = "There was an error perfmorming the operation. #{@booking.errors.first.last}"
        redirect_to rooms_path
      end
    end
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

  def booking_params
    params.require(:booking).permit(:valid_from_date, :valid_from, :valid_to, :number_of_attendants, :room_id)
  end
end
