class Room < ApplicationRecord
  belongs_to :building
  has_many :room_accesories
  has_many :accesories, through: :room_accesories

  scope :active, -> {where("active = 1")}

end
