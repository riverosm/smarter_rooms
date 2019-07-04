class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:new, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    if (params["search_name"] != nil && params["search_name"] != "")
      room_name = params["search_name"]
      if @current_user.is_admin?
        @rooms = Room.where("name like ?", "%#{room_name}%") #.order(:name).page params[:pagina]
      else
        @rooms = Room.active.where("name like ?", "%#{room_name}%") #.order(:name).page params[:pagina]
      end
    else
      if @current_user.is_admin?
        @rooms = Room.all #.order(:name).page params[:pagina]
      else
        @rooms = Room.active.order(:name) #.page params[:pagina]
      end
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    if (!@room.active? && !current_user.is_admin?)
      flash[:danger] = "You are not allowed to access this room."
      redirect_to rooms_url
    end
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @buildings = Building.all.sort_by{|b| b.name}
  end

  # GET /rooms/1/edit
  def edit
    @buildings = Building.all.sort_by{|b| b.name}
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        flash[:success] = "Room was successfully created."
        format.html { redirect_to @room }
        format.json { render :show, status: :created, location: @room }
      else
        error_msgs = ""
        @room.errors.full_messages.each do |msg|
            error_msgs = "<li>#{msg}</li>"
        end
        flash[:danger] = "There was #{@room.errors.count.to_s} error(s): <br /> <ul>#{error_msgs}</ul>"
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
          format.html { redirect_to @room }
          format.json { render :show, status: :ok, location: @room }
        else
          format.html { redirect_to rooms_path }
        end
      else
        error_msgs = ""
        @room.errors.full_messages.each do |msg|
            error_msgs = "<li>#{msg}</li>"
        end
        flash[:danger] = "There was #{@room.errors.count.to_s} error(s): <br /> <ul>#{error_msgs}</ul>"
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      flash[:success] = "Building was successfully destroyed."
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
    end
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
