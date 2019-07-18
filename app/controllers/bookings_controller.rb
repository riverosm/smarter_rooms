class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :create]
  before_action :set_booking, only: [:show, :destroy]

  # GET /bookings
  # GET /bookings.json <- get the user bookings

  def index
    @user_id = params[:user_id]
    @room_id = params[:room_id]

    respond_to do |format|
      format.html { 
        @bookings_today = Booking.where(valid_to: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
        @bookings_lasts = Booking.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).order("created_at DESC")

        if !@user_id.nil? && @user_id != "" && current_user.is_admin?
          @user = User.find(@user_id)
        end
        
        if !@room_id.nil? && @room_id != ""
          @room = Room.find(@room_id)
        end

        render :index 
      }

      format.json {

        if current_user.is_admin?
          if !params[:user_id].nil? && params[:user_id] != ""
            selected_bookings = Booking.where(user: params[:user_id])
          else
            selected_bookings = Booking.all
          end
        else
          selected_bookings = current_user.bookings
        end

        date_start = params[:start].to_datetime
        date_end = params[:end].to_datetime

        selected_bookings = selected_bookings.where(valid_from: date_start..date_end)
    
        if !params[:room_id].nil? && params[:room_id] != ""
          selected_bookings = selected_bookings.where(room: params[:room_id])
        end
    
        # selected_bookings = selected_bookings.order(:valid_from)

        status = 200
        # if more than calendar_max_results, limit and send status 201 (warning)
        if selected_bookings.count > Rails.configuration.smarter_rooms_calendar_max_results
          selected_bookings = selected_bookings.limit(Rails.configuration.smarter_rooms_calendar_max_results)
          status = 201
        end

        if selected_bookings.count == 0
          status = 202
        end

        @user_bookings = []
        selected_bookings.each do |b|
          booking_info = Hash.new
          if current_user.is_admin?
            booking_info["title"] = "<b>Room:</b> " + b.room.name + " <b>User:</b> " + b.user.name
          else
            booking_info["title"] = b.room.name + " room (" + b.room.building.name + ")"
          end
          booking_info["start"] = b.valid_from
          booking_info["end"] = b.valid_to
          booking_info["backgroundColor"] = "#ADD8E6"
          booking_info["borderColor"] = "#000"
          booking_info["extendedProps"] = Hash.new
          booking_info["extendedProps"]["can_delete"] = b.id
          @user_bookings << booking_info
        end
        render json: @user_bookings, status: status
      }
    end
  end

  def show
    redirect_to bookings_path
  end

  def new
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy
    respond_to do |format|
      flash[:warning] = "Booking was successfully canceled."
      format.html { redirect_to bookings_url }
      format.json { head :no_content }
    end
  end

  def create
    check_valid_from = true
    check_valid_to = true
    check_max_attendants = true

    if params["booking"]["valid_from_full"].nil? || params["booking"]["valid_from_full"].to_datetime.class != DateTime
      check_valid_from = false
    end

    if params["booking"]["valid_to_full"].nil? || params["booking"]["valid_to_full"].to_datetime.class != DateTime
      check_valid_to = false
    end

    if booking_params[:number_of_attendants].nil? || booking_params[:number_of_attendants].to_i.class != Integer || booking_params[:number_of_attendants].to_i <= 0
      check_max_attendants = false
    end

    if check_valid_from && check_valid_to && check_max_attendants
      @booking = Booking.new
      @booking.valid_from = params["booking"]["valid_from_full"].to_datetime
      @booking.valid_to = params["booking"]["valid_to_full"].to_datetime
      @booking.number_of_attendants = booking_params[:number_of_attendants]
      @booking.room = @room
      @booking.user = current_user

      if @booking.save
        flash[:success] = "You have successfully booked #{@room.name}"
        redirect_to bookings_path(user_id: current_user.id)
      else
        flash[:danger] = "There was errors perfmorming the operation: <br> #{@booking.errors.first.last}"
        redirect_to new_booking_path(room_id: @room.id)
      end
    else
      flash[:danger] = "Please fill all the required fields"
      redirect_to new_booking_path(room_id: @room.id)
    end
  end

  private
  def set_room
    @room = Room.where("active = 1 AND id = ?",params[:room_id]).first
    if @room.nil?
      flash[:danger] = "You are not allowed to book this room."
      redirect_to rooms_url
    end
  end

  def set_booking
    @booking = Booking.find(params[:id])
    if !current_user.is_admin? && @booking.user != current_user
      flash[:danger] = "You are not allowed to access this booking."
      redirect_to bookings_url
    end
  end

  def booking_params
    params.require(:booking).permit(:valid_from_full, :valid_to_full, :number_of_attendants, :room_id)
  end
end
