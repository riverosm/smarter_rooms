class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 90 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password

  has_many :bookings
  has_many :rooms, through: :bookings

  scope :is_admin, -> {where('admin = 1')}
  scope :is_user, -> {where('admin = 0')}

  paginates_per Rails.configuration.smarter_rooms_users_per_page

  def is_admin?
    self.admin
  end

end
