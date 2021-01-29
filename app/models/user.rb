class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  before_save :downcase_email

  validates :name, presence: true
  validates :email, presence: true,
            uniqueness: true,
            length: {maximum: Settings.users.email.max_length},
            format: {with: VALID_EMAIL_REGEX}

  has_secure_password

  scope :order_by_name, ->{order :name}

  def self.new_token
    SecureRandom.urlsafe_base64
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
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    flash[:danger] = t ".please_login_in"
    redirect_to login_url
  end

  private

  def downcase_email
    email.downcase!
  end
end
