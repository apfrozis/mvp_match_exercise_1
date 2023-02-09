class User < ApplicationRecord
  has_secure_password
  has_many :products, dependent: :destroy
  has_many :sessions, dependent: :destroy

  PASSWORD_REQUIREMENTS = /\A
    (?=.{8,}) # At least 8 characters long
    (?=.*\d) # Contain at least one number
    (?=.*[a-z]) # Contain at least one lowercase letter
    (?=.*[A-Z]) # Contain at least one uppercase letter
    (?=.*[[:^alnum:]]) # Contain at least one symbol
  /x

  validates_uniqueness_of :username
  validates :role, inclusion: %w[seller buyer]
  validates :password, format: PASSWORD_REQUIREMENTS,
            acceptance: { message: 'Password has to be 8 chars long, contain at least one number, ' \
                                   'contain at least one lowercase and one uppercase letter and contain at least one symbol' }

  scope :buyer, -> { where(role: 'buyer') }

  scope :seller, -> { where(role: 'seller') }

  def authenticate(password)
    self.password == password
  end

  def buyer?
    self.role == 'buyer'
  end

  def seller?
    self.role == 'seller'
  end
end
