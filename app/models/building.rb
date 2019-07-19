class Building < ApplicationRecord
  validates :name, presence: true, length: { maximum: 90 }, uniqueness: true

  has_many :rooms

  def get_active_rooms_count
    self.rooms.active.count
  end

  def get_inactive_rooms_count
    self.rooms.inactive.count
  end

  def get_map_image_tag
    # external seeding => id unknown so I'll try by name ...
    building_map_image = "/sites/ibm_martinez_map.png"

    if self.name.downcase.include?("martinez") || self.name.downcase.include?("martínez")
      building_map_image = "/sites/ibm_martinez_map.png"
    elsif self.name.downcase.include?("catalinas")
      building_map_image = "/sites/ibm_catalinas_map.png"
    end

    path = Rails.root.join("public/sites/#{self.id}.jpg")

    ActionController::Base.helpers.image_tag(building_map_image, {
        class: "building_image rounded", size: "200", "data-toggle" => "tooltip",
        "data-original-title" => "LatLng: " + self.latitude.to_s + ", " + self.longitude.to_s, "data-placement" => "right"})
  end

  def get_building_image_tag
    building_image = "/ibm_logo.png"

    # external seeding => id unknown so I'll try by name ...
    if self.name.downcase.include?("martinez") || self.name.downcase.include?("martínez")
      building_image = "/sites/ibm_martinez.jpg"
    elsif self.name.downcase.include?("catalinas")
      building_image = "/sites/ibm_catalinas.jpg"
    end

    # if we know the id
    #path = Rails.root.join("public/sites/#{self.id}.jpg")
    #if File.exists?(path)
    #  building_image = "/sites/#{self.id}.jpg"
    #end
    ActionController::Base.helpers.image_tag(building_image, class: "building_image")
  end
end
