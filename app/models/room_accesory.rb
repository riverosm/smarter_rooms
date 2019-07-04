class RoomAccesory < ApplicationRecord
  belongs_to :room
  belongs_to :accesory

  validates :room, uniqueness: { scope: :accesory }
end
