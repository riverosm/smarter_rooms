class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :valid_to, presence: true
  validates :valid_from, presence: true
  validates :number_of_attendants, presence: true

  validate :room_not_currently_booked
  validate :valid_from_greater_valid_to
  validate :exceed_capacity
  validate :not_in_the_past

  private
    def valid_from_greater_valid_to
      errors.add(:booking, "To time must be greater than the from time.") if valid_to <= valid_from
    end

    def not_in_the_past
      errors.add(:booking, "You can't make bookings in the past.") if valid_to < DateTime.now || valid_from < DateTime.now
    end
    
    def room_not_currently_booked
      errors.add(:booking, "This room is already reserved.") if room_is_booked?
    end

    def room_is_booked?
      room.bookings.where("? BETWEEN valid_from AND valid_to", valid_from + 1.second).count > 0 || 
      room.bookings.where("? BETWEEN valid_from AND valid_to", valid_to - 1.second).count > 0 ||
      room.bookings.where(valid_from: valid_from + 1.second..valid_to - 1.second).count > 0 || 
      room.bookings.where(valid_to: valid_from + 1.second..valid_to - 1.second).count > 0
    end



    def exceed_capacity
      errors.add(:booking, "You can't exceed the room capacity.") if number_of_attendants > room.max_capacity
    end
end