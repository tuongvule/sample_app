class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, presence: true
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
  uniqueness: true,
  format: {with: VALID_EMAIL_REGEX}
  before_save :downcase_email
  has_secure_password

  def downcase_email
    email.downcase!
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Returns the hash digest of the given string.
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    flash[:danger] = t ".please_login_in"
    redirect_to login_url
  end
end
