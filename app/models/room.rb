class Room < ApplicationRecord
  validates :name, presence: true, length: { maximum: 90 }
  validates :code, presence: true, uniqueness: true

  belongs_to :building
  has_many :room_accesories
  has_many :accesories, through: :room_accesories

  scope :active, -> {where("active = 1")}

  has_many :bookings
  has_many :users, through: :bookings

  def get_available_times (date = DateTime.now, from_time = "08:00")
    if date.class == String
      date = Date.parse date
    end
    if date.nil? || date == ""
      date = DateTime.now
    end
    if from_time.nil? || from_time == ""
      from_time = "08:00"
    end
    available_times = []
    # MR TODO - This parameters will be on the database
    begin_hour = from_time.split(":")[0].to_i
    begin_minutes = from_time.split(":")[1].to_i
    end_hour = "20:00".split(":")[0].to_i
    end_minutes = "20:00".split(":")[1].to_i
    step_in_minutes = 5

    begin_time = Time.new(date.year, date.month, date.day, begin_hour, begin_minutes, 0)
    end_time = Time.new(date.year, date.month, date.day, end_hour, end_minutes, 0)

    until end_time < begin_time do
      # MR TODO - Get the available from database
      if begin_time > DateTime.now
        available_times.push({value: begin_time.strftime('%H:%M'), disabled: false})
      end
      begin_time = begin_time + step_in_minutes.minutes
    end

    available_times

  end

end
