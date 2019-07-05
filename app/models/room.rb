class Room < ApplicationRecord
  validates :name, presence: true, length: { maximum: 90 }
  validates :code, presence: true, uniqueness: true

  belongs_to :building
  has_many :room_accesories
  has_many :accesories, through: :room_accesories

  scope :active, -> {where("active = 1")}

  has_many :bookings
  has_many :users, through: :bookings

end
