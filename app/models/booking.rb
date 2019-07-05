class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validate :not_currently_booked
  validates :valid_to, presence: true
  validates :valid_from, presence: true

  scope :active, -> { where("? BETWEEN valid_from AND valid_to", Time.now) }
  scope :not_active, -> { where("? NOT BETWEEN valid_from AND valid_to", Time.now) }

  def not_currently_booked
    errors.add(:rental, "You already have an active rental for this Movie") if currently_rented?
  end

  def currently_booked?
    Rental.active.where(user: user, room: room).count > 0
  end
end
