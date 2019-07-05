class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validate :room_not_currently_booked
  validate :valid_from_greater_valid_to
  validate :exceed_capacity
  validates :valid_to, presence: true
  validates :valid_from, presence: true
  validates :number_of_attendants, presence: true

  private
    def valid_from_greater_valid_to
      errors.add(:booking, "To time must be greater than the from time.") if valid_to <= valid_from
    end
    
    def room_not_currently_booked
      errors.add(:booking, "This room is already reserved.") if room_is_booked?
    end

    def room_is_booked?
      room.bookings.where("? BETWEEN valid_from AND valid_to OR ? BETWEEN valid_from AND valid_to", valid_from, valid_to).count > 0
    end

    def exceed_capacity
      errors.add(:booking, "You can't exceed the room capacity.") if number_of_attendants > room.max_capacity
    end
end