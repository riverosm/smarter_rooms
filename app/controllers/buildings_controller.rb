class BuildingsController < ApplicationController
  before_action :set_building, only: [:show, :edit, :update, :destroy]

  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:show, :edit, :update, :destroy, :new, :create]

  # GET /buildings
  # GET /buildings.json
  def index
    @buildings = Building.all
  end

  # GET /buildings/1
  # GET /buildings/1.json
  def show
  end

  # GET /buildings/new
  def new
    @building = Building.new
  end

  # GET /buildings/1/edit
  def edit
  end

  # POST /buildings
  # POST /buildings.json
  def create
    @building = Building.new(building_params)

    respond_to do |format|
      if @building.save
        flash.now[:success] = "Building was successfully created."
        format.html { redirect_to @building }
        format.json { render :show, status: :created, location: @building }
      else
        error_msgs = ""
        @building.errors.full_messages.each do |msg|
            error_msgs = "<li>#{msg}</li>"
        end
        flash.now[:danger] = "There was #{@building.errors.count.to_s} error(s): <br /> <ul>#{error_msgs}</ul>"
        format.html { render :new }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buildings/1
  # PATCH/PUT /buildings/1.json
  def update
    respond_to do |format|
      if @building.update(building_params)
        flash.now[:success] = "Building was successfully updated."
        format.html { redirect_to @building }
        format.json { render :show, status: :ok, location: @building }
      else
        error_msgs = ""
        @building.errors.full_messages.each do |msg|
            error_msgs = "<li>#{msg}</li>"
        end
        flash.now[:danger] = "There was #{@building.errors.count.to_s} error(s): <br /> <ul>#{error_msgs}</ul>"
        format.html { render :edit }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    @building.destroy
    respond_to do |format|
      flash.now[:success] = "Building was successfully destroyed."
      format.html { redirect_to buildings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building
      @building = Building.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_params
      params.require(:building).permit(:name, :address, :latitude, :longitude)
    end
end
