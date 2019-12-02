class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Image uploader
  mount_uploader :avatar, AvatarUploader

  has_many :properties, dependent: :destroy

  enum status: %i[active blocked]

  scope :by_email, -> (email) { where("LOWER(email) ILIKE ?", "%#{email}%") }
  scope :by_first_name, -> (first_name) { where("LOWER(first_name) ILIKE ?", "%#{first_name}%") }
  scope :by_last_name, -> (last_name) { where("LOWER(last_name) ILIKE ?", "%#{last_name}%") }

  def full_name
    ("#{first_name} #{last_name}").titleize
  end
end
