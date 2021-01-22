class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  before_save :downcase_email

  validates :name, presence: true
  validates :email, presence: true,
            uniqueness: true,
            format: {with: VALID_EMAIL_REGEX}

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
