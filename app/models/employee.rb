class Employee < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save { self.email = email.downcase }
  before_create :create_activation_digest
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
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Employee.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Employee.new_token
    update_attribute(:remember_digest, Employee.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
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

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    EmployeeMailer.account_activation(self).deliver_now
  end

  private

    def create_activation_digest
      self.activation_token = Employee.new_token
      self.activation_digest = Employee.digest(activation_token)
    end

    def photo_size
      if photo.size > 2.megabytes
        errors.add(:photo, "Please upload photo less than 2MB.")
      end
    end

end
