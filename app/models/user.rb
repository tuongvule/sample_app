class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true
  validates :email, presence: true,
            uniqueness: true,
            length: {maximum: Settings.users.email.max_length},
            format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true,
            length: {minimum: Settings.users.password.min_length},
            allow_nil: true
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

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
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

  # Activates an account
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Send an activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
