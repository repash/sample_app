class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: {maximum: 50}
  # equal to -> validates(:name, presence: true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # Sichert nur Einzigartigkeit innerhalb der Applikation, nicht auf der DB !!! (mit Migration lösen)
  has_secure_password
  validates :password, length: { minimum: 6 }

  # Erstellt einen 16 Zeichen langen zufälligen Token
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # Hasht den Token
  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    # Speichert den gehashten Token für den User in der DB
    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
