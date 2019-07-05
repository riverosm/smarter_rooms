class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :create]

  def index
  end

  def show
  end

  def new
  end

  def create
  end

  private
  def set_room
    @room = Room.where("active = 1 AND id = ?",params[:room_id])
    if @room.nil?
      flash[:danger] = "You are not allowed to access this room."
      redirect_to rooms_url
    end

    @room_booked = current_user.bookings.active.any?{|br| br.room == @room}
  end
end
