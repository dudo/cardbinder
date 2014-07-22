class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :remember_token, type: String
  field :admin, type: Boolean, default: false

  has_and_belongs_to_many :cards

  index({ email: 1 }, { unique: true })
  index({ remember_token: 1 })

  before_save { self.email = email.downcase.strip }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  # add and remove cards from binder
  def has? (card)
    !self.cards.where(id: card.id).empty?
  end
  def add! (card)
    self.cards << Card.find(card.id)
  end
  def remove! (card)
    self.cards.where(id: card.id).delete_all
  end

  # password stuff
  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
