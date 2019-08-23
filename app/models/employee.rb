class Employee < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[wamazing]+\.[jp]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  mount_uploader :photo, PhotoUploader
  validate :photo_size
  has_many :team_employees, dependent: :destroy
  has_many :teams, through: :team_employees

  def Employee.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.min_cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Employee.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Employee.new_token
    update_attribute(:remember_digest, Employee.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.search(search)
    if search
      where(['name LIKE ? or position LIKE ? ',
              "%#{search}%", "%#{search}%"])
    else
      all
    end
  end

  private

    def photo_size
      if photo.size > 2.megabytes
        errors.add(:photo, "Please upload photo less than 2MB.")
      end
    end

end
