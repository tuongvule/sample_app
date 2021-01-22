class User < ApplicationRecord
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
  uniqueness: true,
  # length: {maximum: Settings.user.email.max_length},
  format: {with: VALID_EMAIL_REGEX}
  before_save :downcase_email
  has_secure_password

  private
  def downcase_email
    email.downcase_email
  end
end
