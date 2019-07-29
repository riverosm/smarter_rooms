class Room < ApplicationRecord
  validates :name, presence: true, length: { maximum: 90 }
  validates :code, presence: true, uniqueness: true

  belongs_to :building
  has_many :room_accesories
  has_many :accesories, through: :room_accesories

  scope :active, -> {where("active = 1")}
  scope :inactive, -> {where("active = 0")}

  has_many :bookings
  has_many :users, through: :bookings

  paginates_per Rails.configuration.smarter_rooms_rooms_per_page

  def get_bookings (user)
    room_bookings = []
    self.bookings.each do |b|
      room_booking = Hash.new

      if user.is_admin?
        room_booking["id"] = b.id
        room_booking["title"] = b.user.name
        room_booking["backgroundColor"] = "#ADD8E6"
        room_booking["textColor"] = "#000000"
        room_booking["extendedProps"] = Hash.new
        room_booking["extendedProps"]["icon"] = "user-clock"
      else
        if (user == b.user)
          room_booking["title"] = "Your's booking"
          room_booking["backgroundColor"] = "#ADD8E6"
          room_booking["borderColor"] = "#000"
          room_booking["extendedProps"] = Hash.new
          room_booking["extendedProps"]["can_delete"] = b.id
        else
          room_booking["title"] = "Another's booking"
          room_booking["backgroundColor"] = "#CCC"
          room_booking["borderColor"] = "#CCC"
        end
      end
      room_booking["start"] = b.valid_from
      room_booking["end"] = b.valid_to
      room_bookings << room_booking
    end
    room_bookings
  end

  def get_room_accesories_count
    room_accesories_count = []
    Accesory.all.each do |a|
      room_accesories = Hash.new
      room_accesories["name"] = a.name
      room_accesories["quantity"] = self.accesory_count(a)
      if a.icon.nil? || a.icon == ""
        # set default icon if no icon present
        room_accesories["icon"] = "laptop"
      else
        room_accesories["icon"] = a.icon
      end

      room_accesories["class"] = ""
      room_accesories["class"] = "accesory_disabled" if room_accesories["quantity"] == 0
      room_accesories["quantity"] = "No " if room_accesories["quantity"] == 0
      room_accesories_count << room_accesories
    end
    room_accesories_count
  end

  def accesory_count (accesory)
    has_accesory = self.room_accesories.where(accesory: accesory).first
    if has_accesory != nil
      has_accesory.quantity
    else
      0
    end
  end

  def get_estimated_occupants
    # get_estimated_occupants returns:
    #   nil -> room was not found by code
    #   0 -> room is free
    #   # -> estimated occupants

    room_api_full_url = Rails.configuration.smarter_rooms_rooms_api_url + Rails.configuration.smarter_rooms_rooms_api_path + code
    @response = Faraday.get room_api_full_url
    if (@response.status != 200)
      nil
    else
      JSON.parse(@response.body)["estimated_occupants"]
    end
  end
end
