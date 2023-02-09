class User < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :sessions, dependent: :destroy

  validates_uniqueness_of :username
  validates :role, inclusion: %w[seller buyer]

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
