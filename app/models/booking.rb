class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :valid_to, presence: true
  validates :valid_from, presence: true
  validates :number_of_attendants, presence: true

  validate :room_not_currently_booked
  validate :valid_from_greater_valid_to
  validate :exceed_capacity

  private
    def valid_from_greater_valid_to
      errors.add(:booking, "To time must be greater than the from time.") if valid_to <= valid_from
    end
    
    def room_not_currently_booked
      errors.add(:booking, "This room is already reserved.") if room_is_booked?
    end

    def room_is_booked?
      room.bookings.where("(valid_from >= ? and valid_from < ?) or (valid_to >= ? and valid_to < ?)", valid_from, valid_to, valid_from, valid_to).count > 0
    end



    def exceed_capacity
      errors.add(:booking, "You can't exceed the room capacity.") if number_of_attendants > room.max_capacity
    end
end