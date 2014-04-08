class User < ActiveRecord::Base
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: {maximum: 50}
  # equal to -> validates(:name, presence: true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # Sichert nur Einzigartigkeit innerhalb der Applikation, nicht auf der DB !!! (mit Migration lösen)
  has_secure_password
  validates :password, length: { minimum: 6 }
end
