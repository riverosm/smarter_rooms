class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:new, :edit, :update, :destroy, :real_state, :busy_without_booking, :empty_with_booking]

  # GET /rooms
  # GET /rooms.json
  def index
    @title = "All rooms"
    if @current_user.is_admin?
      @rooms = Room.all
    else
      @rooms = Room.active
    end

    if (params["search_name"] != nil && params["search_name"] != "")
      @title = "Rooms search results"
      @rooms = @rooms.where("name like ?", "%#{params["search_name"]}%")
    elsif (params["building"] != nil && params["building"] != "")
      building = Building.find(params[:building])
      @rooms = @rooms.where(building: building)
      @title = building.name + " rooms"
    end

    @rooms = @rooms.order(:name).page params[:pagina]
  end

  # GET /rooms/empty_with_booking
  # GET /rooms/empty_with_booking.json
  def empty_with_booking
    respond_to do |format|
      format.html { render :empty_with_booking }
      format.json {
        @rooms = []
        booked_now_rooms = Booking.booked_now.map{|booked_now| booked_now.room}
        if booked_now_rooms == []
          booked_now_rooms = ''
        end
        Room.where("id IN (?)", booked_now_rooms).each do |booked_room|
          room_info = Hash.new
          room_info["estimated_occupants"] = booked_room.get_estimated_occupants

          if !room_info["estimated_occupants"].nil? && room_info["estimated_occupants"] == 0
            room_info["name"] = booked_room.name
            room_info["building"] = booked_room.building.name
            room_info["max_capacity"] = booked_room.max_capacity
            room_info["state"] = "Empty with active booking!"
            room_info["class"] = "danger"
            room_info["used_percent"] = (room_info["estimated_occupants"].to_f / room_info["max_capacity"].to_f * 100).ceil
            @rooms << room_info
          end
        end
        render json: @rooms
      }
    end
  end

  # GET /rooms/real_state
  # GET /rooms/real_state.json
  def real_state
    respond_to do |format|
      format.html { render :real_state }
      format.json {
        @rooms = []
        Room.all.each do |r|
          room_info = Hash.new
          room_info["name"] = r.name
          room_info["building"] = r.building.name
          room_info["max_capacity"] = r.max_capacity
          room_info["estimated_occupants"] = r.get_estimated_occupants
          room_info["used_percent"] = 100

          if room_info["estimated_occupants"].nil?
            room_info["state"] = "No info!"
            room_info["class"] = "danger"
            room_info["used_percent"] = 0
            room_info["estimated_occupants"] = "Unknown"
          elsif room_info["estimated_occupants"] == 0
            room_info["state"] = "Empty room!"
            room_info["class"] = "success"
            room_info["used_percent"] = 0
          elsif room_info["max_capacity"] == room_info["estimated_occupants"]
            room_info["state"] = "Filled room!"
            room_info["class"] = "warning"
          elsif room_info["max_capacity"] > room_info["estimated_occupants"]
            room_info["state"] = "Busy room!"
            room_info["class"] = "primary"
            room_info["used_percent"] = (room_info["estimated_occupants"].to_f / room_info["max_capacity"].to_f * 100).ceil
          elsif room_info["max_capacity"] < room_info["estimated_occupants"]
            room_info["state"] = "Overfilled room!"
            room_info["class"] = "danger"
          end
          @rooms << room_info
        end
        render json: @rooms
      }
    end
  end

  # GET /rooms/busy_without_booking
  # GET /rooms/busy_without_booking.json
  def busy_without_booking
    respond_to do |format|
      format.html { render :busy_without_booking }
      format.json {
        @rooms = []
        booked_now_rooms = Booking.booked_now.map{|booked_now| booked_now.room}
        if booked_now_rooms == []
          booked_now_rooms = ''
        end
        Room.where("id NOT IN (?)", booked_now_rooms).each do |not_booked_room|
          room_info = Hash.new
          room_info["estimated_occupants"] = not_booked_room.get_estimated_occupants

          if !room_info["estimated_occupants"].nil? && room_info["estimated_occupants"] > 0
            room_info["name"] = not_booked_room.name
            room_info["building"] = not_booked_room.building.name
            room_info["max_capacity"] = not_booked_room.max_capacity
            room_info["state"] = "Busy without booking!"
            room_info["class"] = "danger"
            room_info["used_percent"] = (room_info["estimated_occupants"].to_f / room_info["max_capacity"].to_f * 100).ceil
            @rooms << room_info
          end
        end
        render json: @rooms 
      }
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    if (!@room.active? && !current_user.is_admin?)
      flash[:danger] = "You are not allowed to access this room."
      redirect_to rooms_url
    else
      respond_to do |format|
        format.html { redirect_to rooms_path }
        room_info = Hash.new
        format.json {
          room_info["room_info"] = @room
          booking_info = Hash.new
          room_info["bookings"] = @room.get_bookings(current_user)
          if params["only_bookings"] == "1"
            render json: room_info["bookings"]
          else
            render json: room_info
          end
        }
      end
    end
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @buildings = Building.all.sort_by{|b| b.name}
    @building_id = ""
    if !params[:building_id].nil?
      @building_id = params[:building_id]
    end
  end

  # GET /rooms/1/edit
  def edit
    @buildings = Building.all.sort_by{|b| b.name}
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    @buildings = Building.all.sort_by{|b| b.name}

    respond_to do |format|
      if @room.save
        flash[:success] = "Room was successfully created."
        format.html { redirect_to rooms_path(building: room_params[:building_id]) }
        format.json { render :show, status: :created, location: @room }
      else
        error_msgs = ""
        @room.errors.full_messages.each do |msg|
            error_msgs = "<li>#{msg}</li>"
        end
        flash.now[:danger] = "There was #{@room.errors.count.to_s} error(s): <br /> <ul>#{error_msgs}</ul>"
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        flash[:success] = "Room was successfully updated."
        if (room_params.has_key?(:name))
          format.html { redirect_to rooms_path(building: room_params[:building_id]) }
          format.json { render :show, status: :ok, location: @room }
        else
          format.html { redirect_to rooms_path(building: room_params[:building_id]) }
        end
      else
        error_msgs = ""
        @room.errors.full_messages.each do |msg|
            error_msgs = "<li>#{msg}</li>"
        end
        flash.now[:danger] = "There was #{@room.errors.count.to_s} error(s): <br /> <ul>#{error_msgs}</ul>"
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    # Remove for enable delete
    #@room.destroy
    #respond_to do |format|
    #  flash[:success] = "Room was successfully destroyed."
    #  format.html { redirect_to rooms_url }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :code, :floor, :max_capacity, :active, :building_id)
    end
end
