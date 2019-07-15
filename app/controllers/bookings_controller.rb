class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :create]
  before_action :set_booking, only: [:show, :destroy]

  # GET /bookings
  # GET /bookings.json <- get the user bookings

  def index
    user_next_five_days_bookings = current_user.bookings.where(valid_from: DateTime.now..DateTime.now+5.days).order(:valid_from)
    respond_to do |format|
      format.html { 
        @bookings_today = Booking.where(valid_to: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
        @bookings_lasts = Booking.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).order("created_at DESC")
        @user_next_five_days_bookings = user_next_five_days_bookings
        render :index 
      }

      format.json {
        @user_bookings = []
        user_next_five_days_bookings.each do |b|
          booking_info = Hash.new
          booking_info["title"] = b.room.name + " room (" + b.room.building.name + ")"
          booking_info["start"] = b.valid_from
          booking_info["end"] = b.valid_to
          booking_info["backgroundColor"] = "#ADD8E6"
          booking_info["borderColor"] = "#000"
          booking_info["extendedProps"] = Hash.new
          booking_info["extendedProps"]["can_delete"] = b.id
          @user_bookings << booking_info
        end
        render json: @user_bookings
      }
    end
  end

  def show
  end

  def new
  end

  def destroy
    # Remove for enable delete
    #@booking.destroy
    #respond_to do |format|
    #  flash[:warning] = "Booking was successfully canceled."
    #  format.html { redirect_to bookings_url }
    #  format.json { head :no_content }
    #end
  end

  def create
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

  def set_booking
    if !current_user.is_admin? && Booking.find(params[:id]).user != current_user
      flash[:danger] = "You are not allowed to access this booking."
      redirect_to bookings_url
    end
  end

  def booking_params
    params.require(:booking).permit(:valid_from_full, :valid_to_full, :number_of_attendants, :room_id)
  end
end
