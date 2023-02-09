class User < ApplicationRecord
  #has_secure_password
  has_many :products, dependent: :destroy
  has_many :sessions, dependent: :destroy

  validates_uniqueness_of :username
  validates :role, inclusion: %w[seller buyer]
  validates :password, format: { with: /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/ ,
                                 message: 'Not valid password. Must be at least 6 characters and include one number and one letter.', multiline: true}

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
