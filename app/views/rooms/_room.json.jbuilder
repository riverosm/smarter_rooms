#json.partial! "rooms/room", room: @room
#json.array! @room.get_available_times(params[:date], params[:from_time])
